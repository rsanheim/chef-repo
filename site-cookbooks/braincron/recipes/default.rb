directory "/data" do
  owner node[:user]
  mode 0755
end

node[:apps].each do |app|

  cap_directories = [
    "/srv/#{app}/shared",
    "/srv/#{app}/shared/config",
    "/srv/#{app}/shared/system",
    "/srv/#{app}/releases" 
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
  docroot "/srv/braincron/current/public"
  server_name "braincron.#{node[:domain]}"
  server_aliases [ "braincron", node[:hostname] ]
  rails_env "production"
  template "braincron.conf.erb"
end
