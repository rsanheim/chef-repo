name "web"
recipes "braincron", "braincron::deploy"

override_attributes "passenger" => { "version" => "2.2.5" }