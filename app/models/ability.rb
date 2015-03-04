class Ability
  include CanCan::Ability
  
  attr_reader :person
  
  def initialize(person)
    @person = person
    
    alias_action [:show_description], :to => :read
    
    can :read, Event
    cannot :read, ProposedEvent
    can :read, Schedule, :published => true
    
    if person
      if person.admin?
        can :manage, :all
      else
        # TODO: generalize this to work with multiple event levels deep
        
        can :manage, Event, :id => staff_event_ids
        can :view_attendances, Event, :attendees_visible => true, :attendances => { :person_id => person.id }
        can :manage, Event, :parent_id => staff_event_ids
        
        can :manage, Schedule, :event_id => staff_event_ids
        can :manage, Schedule, :event => { :parent_id => staff_event_ids }
      
        can :manage, Attendance, :event_id => staff_event_ids
        can :manage, Attendance, :event => { :parent_id => staff_event_ids }
        can(:read, Attendance) { |att| can? :view_attendances, att.try(:event) }
        
        can :create, ProposedEvent
        can :manage, ProposedEvent, :parent_id => staff_event_ids
        can [:read, :update, :destroy], ProposedEvent, :proposer_id => person.id
      end
    end
  end
  
  def staff_event_ids
    @staff_event_ids ||= begin
      Event.all(
        :joins => :attendances, 
        :conditions => ["attendances.person_id = ? AND attendances.is_staff = ? AND (type != 'ProposedEvent' OR type IS NULL)", person.id, true], 
        :select => "events.id"
      ).map(&:id)
    end
  end
end