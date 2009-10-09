require File.join(File.dirname(__FILE__), *%w[.. .. .. vendor chef-deploy lib chef-deploy])

deploy "#{node[:app_root]}/braincron" do
   repo "git://github.com/rsanheim/braincron.git"
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