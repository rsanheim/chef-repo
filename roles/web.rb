name "web"
recipes "passenger_apache2", "brainjo"

override_attributes "passenger" => { "version" => "2.2.5" }