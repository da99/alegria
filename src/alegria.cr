
require "kemal"

Dir.cd("/apps/alegria")

get "/" do
  File.read("html5/root/index.html")
end

get "/css/:raw_name/style.css" do |env|
  raw_name = env.params.url["raw_name"] || "root"
  name = (raw_name[/^[a-z0-9\_]+$/]? && raw_name) || "root"
  File.read("html5/#{name}/style.css")
end


