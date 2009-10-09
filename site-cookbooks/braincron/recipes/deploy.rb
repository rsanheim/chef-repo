node[:gems].each do |gem|
  gem_package gem do
    action :install
  end
end

template "#{node[:app_root]}/#{node[:app_name]}/shared/config/database.yml" do
  source "database.yml.erb"
  owner "deploy"
  group "deploy"
  variables :app_name => node[:app_name]
  mode "0664"
end

deploy "#{node[:app_root]}/#{node[:app_name]}" do
  repo "git://github.com/rsanheim/braincron.git"
  revision "HEAD" # or "HEAD" or "TAG_for_1.0" or (subversion) "1234"
  user "deploy"
  enable_submodules true
  migrate true
  migration_command "rake db:migrate"
  environment "RAILS_ENV" => "production"
  shallow_clone true
  restart_command "touch tmp/restart.txt"
  action :deploy # or :rollback
end
