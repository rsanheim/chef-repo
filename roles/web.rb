name "web"
recipes "passenger_apache2", "braincron"

override_attributes "passenger" => { "version" => "2.2.5" }