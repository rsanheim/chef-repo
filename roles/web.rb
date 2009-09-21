name "web"
recipes "passenger_apache2"

override_attributes "passenger" => { "version" => "2.2.5" }

# web_app "some_rails_app" do
#   docroot "/srv/some-app/current/public"
#   template "some_rails_app.conf.erb"
# end