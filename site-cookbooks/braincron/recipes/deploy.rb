include_recipe "sqlite"
gem_package "sqlite3-ruby"
gem_package "antage-postgres" do
  source "http://gems.github.com"
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
  symlink_before_migrate  "config/database.yml" => "config/database.yml"
  before_migrate do
    current_release = release_path

    execute "create db" do
      cwd current_release
      user "postgres"
      command "rake db:create"
    end
  end
  action :deploy # or :rollback
end
