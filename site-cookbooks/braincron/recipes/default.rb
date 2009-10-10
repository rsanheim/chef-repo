app_root = node[:app_root]
app = "braincron"

package "vim"
package "sendmail"

user "deploy" do
  home "/home/deploy"
end

execute "create postgres user 'deploy'" do
  command "createuser deploy --createdb --superuser"
  user "postgres"
  only_if do
    # Only setup the user if there is not one already in postgres
    result = %x[/usr/bin/psql -U postgres -c "select * from pg_user where usename = 'deploy'"]
    result =~ /0 row/
  end
end

directory app_root do
  mode 0755
end

cap_directories = [
  "#{app_root}/#{app}",
  "#{app_root}/#{app}/shared",
  "#{app_root}/#{app}/shared/config",
  "#{app_root}/#{app}/shared/system",
  "#{app_root}/#{app}/shared/log",
  "#{app_root}/#{app}/releases"
]

cap_directories.each do |dir|
  directory dir do
    owner "deploy"
    group "deploy"
    mode 0755
    recursive true
  end
end

include_recipe "rails"
include_recipe "apache2"
include_recipe "passenger_apache2"
include_recipe "passenger_apache2::mod_rails"

apache_site "000-default" do
  enable false
end

web_app "braincron" do
  docroot "#{app_root}/braincron/current/public"
  server_name "braincron.#{node[:domain]}"
  server_aliases [ "braincron", node[:hostname] ]
  rails_env "production"
  template "braincron.conf.erb"
end