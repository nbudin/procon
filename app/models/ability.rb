class Ability
  include CanCan::Ability
  
  def initialize(person)
    alias_action [:show_description], :to => :read
    
    can :read, Event
    cannot :read, ProposedEvent
    can :read, Schedule, :published => true
    
    if person
      if person.admin?
        can :manage, :all
      else
        # TODO: generalize this to work with multiple event levels deep
        
        event_staff_conds = { :attendances => { :person_id => person.id, :is_staff => true } }
        
        can :manage, Event, event_staff_conds
        can :view_attendances, Event, :attendees_visible => true, :attendances => { :person_id => person.id }
        can :manage, Event, :parent => event_staff_conds
        
        can :manage, Schedule, :event => event_staff_conds
        can :manage, Schedule, :event => { :parent => event_staff_conds }
      
        can :manage, Attendance, :event => event_staff_conds
        can :manage, Attendance, :event => { :parent => event_staff_conds }
        can(:read, Attendance) { |att| can? :view_attendances, att.try(:event) }
        
        can :create, ProposedEvent
        can :manage, ProposedEvent, :parent => event_staff_conds
        can [:read, :update, :destroy], ProposedEvent, :proposer_id => person.id
      end
    end
  end
end