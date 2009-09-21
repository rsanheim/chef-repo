#
# Chef Solo Config File
#

log_level          :debug
log_location       STDOUT
file_cache_path    "/srv/chef/cookbooks"
role_path "/srv/chef/roles"
ssl_verify_mode    :verify_none
Chef::Log::Formatter.show_time = true
