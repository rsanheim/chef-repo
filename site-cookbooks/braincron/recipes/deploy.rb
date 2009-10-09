deploy "#{node[:app_root]}/braincron" do
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
