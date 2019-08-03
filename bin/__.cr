
full_cmd = ARGV.map(&.strip).join(' ')

require "../src/alegria"

case
when full_cmd == "start http server"
  Kemal.run(port: 4567)
else
  STDERR.puts "Unknown command: #{ARGV.inspect}"
  Process.exit 1
end # case
