Factory.define :email_address do |ea|
  ea.address 'test@example.com'
end

Factory.define :person do |p|
  p.firstname 'Joe'
  p.lastname 'User'
  p.gender 'male'
  p.association :primary_email_address, :factory => :email_address
end

Factory.define :role do |r|
end

Factory.define :superadmin_person, :parent => :person do |p|
  p.role_objects {|r| [ r.association(:role, :name => 'superadmin') ]}
end

Factory.define :procon_profile do |p|
  p.association :person, :factory => :person
  p.nickname 'Squinky'
  p.phone '212-867-5309'
  p.best_call_time 'never'
end

Factory.define :superadmin_profile, :parent => :procon_profile do |p|
  p.association :person, :factory => :superadmin_person
end


Factory.define :event do |e|
  e.fullname "My awesome event"
end

Factory.define :proposed_event do |e|
  e.fullname "My event that I think will be awesome"
end

Factory.define :event_with_parent, :parent => :event do |e|
  e.association :parent, :factory => :event, :fullname => "My awesome convention"
end

Factory.define :attendance do |att|
  att.association :event, :factory => :event
end

Factory.define :staff_attendance, :parent => :attendance do |att|
  att.is_staff true
end

Factory.define :attendee_profile, :parent => :procon_profile do |p|
  p.after_build { |profile| Factory.create(:attendance, :person => profile.person) }
end

Factory.define :staff_profile, :parent => :procon_profile do |p|
  p.after_build { |profile| Factory.create(:staff_attendance, :person => profile.person) }
end

Factory.define :proposer_profile, :parent => :procon_profile do |p|
  p.after_build { |profile| Factory.create(:proposed_event, :proposer => profile.person)}
end
