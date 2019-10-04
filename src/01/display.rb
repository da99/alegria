

def process?(x)
  begin
    Process.getpgid( x )
    true
  rescue Errno::ESRCH
    false
  end
end # def

def on_minute?
  now = Time.new
  sec = now.strftime("%-S").to_i
  sec < 2
end # def

def on_5th_minute?
  now = Time.new
  min = now.strftime("%-M").to_i
  sec = now.strftime("%-S").to_i
  on_minute? && ((min % 5) == 0)
end # def

def on_15th_minute?
  now = Time.new
  min = now.strftime("%-M").to_i
  sec = now.strftime("%-S").to_i
  on_minute? && ((min % 15) == 0)
end # def

def reboot_time?
  now = Time.new
  min = now.strftime("%-M").to_i
  hour24   = now.strftime("%-H").to_i
  hour24 == 10 && min == 5
end # def

def on_hour?
  now = Time.new
  min = now.strftime("%-M").to_i
  on_minute? && min == 0
end # def

def sleep_to_hour
  now = Time.new
  min = now.strftime("%-M").to_i
  sec = now.strftime("%-S").to_i
  secs_left = (60 - sec) + 1
  mins_left  = 60 - min
  sleep(secs_left + (60 * mins_left))
end #def

def sleep_to_min(count = 1)
  now = Time.new
  min = now.strftime("%-M").to_i
  sec = now.strftime("%-S").to_i

  secs_left = (60 - sec) + 1

  sleep(secs_left)

  if min < 55
    count = 1
  end
  mins_left = 60 * (count - 1)
  sleep( 60 * mins_left) if mins_left > 0
end # def

def sleep_to_30
  now = Time.new
  sec = now.strftime("%-S").to_i
  if sec < 30
    sleep(30 - sec + 1)
  else
    sleep(60 - sec + 1)
  end
end # def

def next_item(current, list)
  new_item = nil
  list.reverse.find { |x|
    if x == current
      true
    else
      new_item = x
      false
    end
  }
  new_item || list.first
end # def

class Alegria
  PHOTOS = "
    kids.special.01.jpg
    01.coxa.combo.stro.jpg
  ".split

  MANUAL_SLIDESHOW = "
    kids.special.01.jpg
    01.coxa.combo.stro.jpg
    order_here.combo.jpg
    order_here.coxa.jpg
    order_here.strogan.jpg
  ".split

  def self.stop_slideshow
    @@slideshow = false
  end # def

  def self.start_slideshow
    @@slideshow = true
  end # def

  start_slideshow

  def self.back
    stop_slideshow
    pcmanfm_wallpaper(prev_item(current_photo, MANUAL_SLIDESHOW))
  end # def

  def self.forward
    stop_slideshow
    pcmanfm_wallpaper(next_item(current_photo, MANUAL_SLIDESHOW))
  end # def

  def self.slideshow?
    @@slideshow
  end

  def self.state
    [:@@slideshow, slideshow?]
  end

  def self.closed?
    !open?
  end # def

  def self.open?
    now    = Time.new
    day    = now.strftime("%a")
    hour24 = now.strftime("%-H").to_i
    hour12 = now.strftime("%-I").to_i

    return false if hour24 < 11
    return true if hour24 >= 11 && hour24 <= 13

    case
    when "Mon"
      hour12 >= 3
    when "Tue", "Wed", "Thu"
      hour12 >= 8
    when "Fri", "Sat"
      hour12 >= 9
    when "Sun"
      hour12 >= 4
    else
      false
    end # case

  end # def

  def self.current_photo
    @@current_photo ||= false
  end # def

  def self.current_photo?(x)
    @@current_photo == x
  end # def

  def self.kids_special?
    now    = Time.new
    day    = now.strftime("%a")
    hour12 = now.strftime("%-I").to_i

    open? && (day == "Tue" || day == "Wed") && hour12 >= 4
  end # def

  def self.closed?
    !open?
  end # def

  def self.stroganoff_special?
    day    = Time.new.strftime("%a")
    open? && (day == "Mon" || day == "Tue")
  end # def

  def self.next_photo
    case
    when kids_special?
      "kids.special.01.jpg"

    when stroganoff_special?
      "order_here.strogan.jpg"

    when open?
      next_item(current_photo, PHOTOS)
    else
      "mark_11_24.jpg"
    end
  end # def


  def self.pcmanfm_wallpaper(new_photo)
    old_photo = current_photo
    if old_photo != new_photo
      full_path = "#{Dir.pwd}/images/final/01/#{new_photo}"
      STDERR.puts "=== Updating background to: #{full_path}"
      `pcmanfm --set-wallpaper "#{full_path}" --wallpaper-mode=fit`
      @@current_photo = new_photo
      true
    else
      false
    end
  end # def

end # module

Signal.trap('SIGUSR1') { Alegria.back }
Signal.trap('SIGUSR2') { Alegria.forward }
Signal.trap('SIGWINCH') { Alegria.start_slideshow }

def hide_mouse_cursor
  `xdotool mousemove 1080 1980`
end


`wmctrl -l`.strip.split("\n").each { |x| `xdotool windowminimize "#{x.split.first}"` }

hide_mouse_cursor
pid = Process.pid
fork {

  puts "=== Starting forked process: #{Process.pid}"
  while process?(pid)
    if reboot_time?
      fork {
        sleep 60
        `git pull`
        `sudo reboot`
      }
    end
    sleep_to_min
  end
  puts "=== Done forked process: #{Process.pid}"
}

fork {
  puts "=== Starting forked process: #{Process.pid}"
  while process?(pid)
    if on_15th_minute?
      fork { `git pull` }
    end
    sleep_to_min
  end
  puts "=== Done forked process: #{Process.pid}"
}

fork {
  puts "=== Starting forked process: #{Process.pid}"
  while process?(pid)
    if on_5th_minute?
      hide_mouse_cursor
    end
    sleep_to_min
  end
  puts "=== Done forked process: #{Process.pid}"
}


while true
  if !Alegria.slideshow?
    sleep 1
    next
  end

  if Alegria.open?
    case
    when Alegria.kids_special?
      Alegria.pcmanfm_wallpaper("kids.special.01.jpg")
    when Alegria.stroganoff_special?
      Alegria.pcmanfm_wallpaper("order_here.strogan.jpg")
    when Alegria.current_photo?("kids.special.01.jpg")
      Alegria.pcmanfm_wallpaper("01.coxa.combo.stro.jpg")
      sleep_to_min(3)
      next
    else
      Alegria.pcmanfm_wallpaper("kids.special.01.jpg")
      sleep 15
      next
    end
    sleep_to_min
    next
  end # if Alegria.open?

  Alegria.pcmanfm_wallpaper("mark_11_24.jpg")
end # while




