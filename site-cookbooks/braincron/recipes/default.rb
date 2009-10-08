web_app "braincron" do
  docroot "/srv/braincron/public"
  server_name "braincron.#{node[:domain]}"
  server_aliases [ "braincron", node[:hostname] ]
  rails_env "production"
  template "braincron.conf.erb"
end
