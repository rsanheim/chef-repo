require 'chef-deploy'

deploy "#{app_root}/myrackapp" do
   repo "git://github.com/engineyard/rack-app.git"
   branch "HEAD"
   user "deploy"
   role "web"
   enable_submodules true
   migrate true
   migration_command "rake db:migrate"
   environment "production"
   shallow_clone true
   revision "HEAD"
   restart_command "touch tmp/restart.txt" # "monit restart all -g foo", etc.
   action :deploy # or :rollback
 end