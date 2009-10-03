web_app "brainjo" do
  docroot "/srv/brainjo/public"
  server_name "brainjo.#{node[:domain]}"
  server_aliases [ "brainjo", node[:hostname] ]
  rails_env "production"
  template "brainjo.conf.erb"
end
