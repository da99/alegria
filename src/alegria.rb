
def jpg_for_now(num, raw_dir)
  dir   = File.join(Dir.pwd, raw_dir)
  jpgs  = `find "#{dir}" -maxdepth 1 -mindepth 1 -type f -iname '*.jpg' -or -iname '*.png' `.split
  index = (num % jpgs.size).to_i

  jpgs[index] || File.join(Dir.pwd, "images/chicken.drumstrick.01.jpg")
end # def

def jpg_for_min(raw_dir)
  jpg_for_now(Time.now.min, raw_dir)
end # def

def jpg_for_hour(raw_dir)
  jpg_for_now(Time.now.hour, raw_dir)
end # def

def jpg_for_today(raw_dir)
  jpg_for_now(Time.now.day, raw_dir)
end # def

def hide_mouse_cursor
  `xdotool mousemove 1080 1980`
end

def minimize_windows
  `wmctrl -l`.strip.split("\n").each { |x| `xdotool windowminimize "#{x.split.first}"` }
end

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
end # def

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

def auto_reboot
  pid = Process.pid
  fork {
    puts "=== Starting forked process: #{Process.pid}"
    while process?(pid)
      if Alegria::Auto_Reboot.yes?
        sleep 60
        Alegria::Auto_Reboot.now!
      end
      sleep_to_min
    end
    puts "=== Done forked process: #{Process.pid}"
  }
end # def auto_reboot

def auto_git_pull
  pid = Process.pid
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
end # def auto_git_pull

def auto_hide_cursor
  pid = Process.pid
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
end # def auto_hide_cursor

class Alegria

  def self.before_hour?(hour)
    return false if Time.now.min == 59 && hour12 == (hour - 1)
    hour12 < hour
  end

  def self.hour12
    Time.new.strftime("%-I").to_i
  end

  def self.closed?
    !open?
  end # def

  def self.open?
    return true

    now    = Time.new
    day    = now.strftime("%a")
    hour24 = now.strftime("%-H").to_i
    hour12 = now.strftime("%-I").to_i

    return false if hour24 < 11
    return true if hour24 >= 11 && hour24 < 19

    # case day
    # when "Fri", "Sat"
    #   before_hour? 9
    # when "Sun"
    #   before_hour? 4
    # else
      # before_hour? 3
    # end # case

  end # def

  def self.tues_after4pm?
    now    = Time.new
    day    = now.strftime("%a")
    hour12 = now.strftime("%-I").to_i

    open? && day == "Tue" && hour12 >= 4
  end # def

  def self.wed_after4pm?
    now    = Time.new
    day    = now.strftime("%a")
    hour12 = now.strftime("%-I").to_i

    open? && day == "Wed" && hour12 >= 4
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
    open? && (day == "Mon")
  end # def

  def self.pcmanfm_wallpaper(raw_photo)
    new_photo = File.expand_path(raw_photo)
    if !(new_photo.index(Dir.pwd) == 0)
      raise "invalid image path: #{new_photo.inspect}"
    end

    full_path = new_photo
    STDERR.puts "=== Updating background to: #{full_path}"
    `pcmanfm --set-wallpaper "#{full_path}" --wallpaper-mode=crop`
    true
  end # def

  def self.pcmanfm_desktop_off
    `pcmanfm --desktop-off`
  end

  def self.feh_bg_center(*args)
    `feh --bg-center #{ args.map { |str| File.expand_path(str).inspect }.join(" ") }`
  end

  class Auto_Reboot
    @@last_msg = ""
    CACHE_FILE = "reboot.request.txt"
    class << self

      def now!
        @@last_msg = latest
        `git pull`
        `sudo reboot`
      end # def now!

      def latest
        File.read(CACHE_FILE)
      end

      def yes?
        @@last_msg == latest || reboot_time?
      end

      def reboot_time?
        now = Time.new
        min = now.strftime("%-M").to_i
        hour24   = now.strftime("%-H").to_i
        hour24 == 10 && min == 5
      end # def
    end # class
  end # class Auto_Reboot

end # module
