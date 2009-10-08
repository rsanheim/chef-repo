name "web"
recipes "apache2", "passenger_apache2", "passenger_apache2::mod_rails", "braincron"

override_attributes "passenger" => { "version" => "2.2.5" }