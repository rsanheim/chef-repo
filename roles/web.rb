include_recipe "apache2"
include_recipe "passenger"
include_recipe "rails"

web_app "some_rails_app" do
  docroot "/srv/some-app/current/public"
  template "some_rails_app.conf.erb"
end