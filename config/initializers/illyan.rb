Illyan.profile_class = ProconProfile
Illyan.js_framework = "jquery"

Acl9::config.merge!({
  :default_subject_class_name => 'ProconProfile',
  :default_subject_method => 'procon_profile'
})