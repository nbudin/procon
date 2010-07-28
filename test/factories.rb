Factory.sequence :email do |n|
  "test#{n}@example.com"
end

Factory.define :person do |p|
  p.username { Factory.next :email }
  p.firstname "Test"
  p.lastname "User"
end

Factory.define :event do |e|
  e.fullname "An event of some sort"
end

Factory.sequence :domain do |n|
  "www.examplesite#{n}.com"
end

Factory.define :virtual_site do |vs|
  vs.domain { Factory.next :domain }
end

Factory.define :proposal, :class => "ProposedEvent" do |p|
  p.fullname "Saturday night dance party"
  p.after_build do |proposal|
    proposal.parent = Factory.build(:event)
  end
end