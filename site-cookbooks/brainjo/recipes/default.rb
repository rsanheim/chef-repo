web_app "myproj" do
  docroot "/srv/myproj/public"
  server_name "myproj.#{node[:domain]}"
  server_aliases [ "myproj", node[:hostname] ]
  rails_env "production"
  template "brainjo.conf.erb"
end