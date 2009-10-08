include_recipe "apache2"
include_recipe "passenger_apache2"
include_recipe "rails"

app_root = node[:app_root]

directory app_root do
  owner node[:user]
  mode 0755
end

node[:apps].each do |app|

  cap_directories = [
    "#{app_root}/#{app}/shared",
    "#{app_root}/#{app}/shared/config",
    "#{app_root}/#{app}/shared/system",
    "#{app_root}/#{app}/releases" 
  ]

  cap_directories.each do |dir|
    directory dir do
      owner node[:user]
      mode 0755
      recursive true
    end
  end

end

web_app "braincron" do
  docroot "#{app_root}/braincron/current/public"
  server_name "braincron.#{node[:domain]}"
  server_aliases [ "braincron", node[:hostname] ]
  rails_env "production"
  template "braincron.conf.erb"
end
