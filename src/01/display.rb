


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

def sleep_to_min
  now = Time.new
  sec = now.strftime("%-S")
  secs_left = (60 - sec) + 1
  sleep(secs_left)
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
    order_here.combo.jpg
    order_here.coxa.jpg
    order_here.strogan.jpg
  ".split

  CURRENT_PHOTO = PHOTOS.first

  def self.closed?
    !open?
  end # def

  def self.open?
    now    = Time.new
    day    = now.strftime("%a")
    hour24   = now.strftime("%-H").to_i
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

  def self.kids_special?
    now    = Time.new
    min    = now.strftime("%-M").to_i
    sec    = now.strftime("%-S").to_i
    day    = now.strftime("%a")
    hour24 = now.strftime("%-H").to_i
    hour12 = now.strftime("%-I").to_i
    open? && (day == "Tue" || day == "Wed") && hour12 >= 4
  end # def

  def self.closed?
    !open?
  end # def

  def self.stroganoff_special?
    now    = Time.new
    min    = now.strftime("%-M").to_i
    sec    = now.strftime("%-S").to_i
    day    = now.strftime("%a")
    hour24 = now.strftime("%-H").to_i
    hour12 = now.strftime("%-I").to_i
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

  def self.update_bg
    old_photo = current_photo
    new_photo = next_photo
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

def hide_mouse_cursor
  `xdotool mousemove 1080 1980`
end


`wmctrl -l`.strip.split("\n").each { |x|
  `xdotool windowminimize "#{x.split.first}"`
}
hide_mouse_cursor

while true
  if reboot_time?
    sleep 60
    `git pull`
    `sudo reboot`
  end

  if on_5th_minute?
    hide_mouse_cursor
  end

  if on_15th_minute?
    `git pull`
  end

  Alegria.update_bg
  sleep_to_30
end # while




