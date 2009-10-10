name "web"
recipes "braincron", "braincron::deploy", "braincron:cron"

default_attributes "app_name" => "braincron"
override_attributes "passenger" => { "version" => "2.2.4" }