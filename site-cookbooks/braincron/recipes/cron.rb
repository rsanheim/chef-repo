current_path = "#{node[:app_root]}/#{node[:app_name]}/current"

cron "run reminders every minute" do
  user "deploy"
  path "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin"
  command "cd #{current_path} && RAILS_ENV=production /usr/bin/rake producer:run"
end