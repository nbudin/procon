class Ability
  include CanCan::Ability
  
  def initialize(person)
    alias_action [:show_description], :to => :read
    
    can :read, Schedule, :published => true
    
    if person
      if person.admin?
        can [:read, :create, :update, :destroy, :view_attendees], Event
        can [:read, :create, :update, :destroy], VirtualSite
        can [:read, :create, :update, :destroy], Schedule
        can [:read, :create, :update, :destroy, :accept, :reject], ProposedEvent
      else
        can :manage, Event do |action, event|
          event.staff.include? person || (event.parent && can?(action, event.parent))
        end
        can :view_attendees, Event do |event|
          can?(:update, event) || (event.attendees_visible && event.all_attendees.include?(person))
        end
        
        can [:read, :create, :update, :destroy], Schedule do |schedule|
          can?(:admin_schedules, event)
        end
        
        can :create, ProposedEvent
        can [:read, :update, :destroy], ProposedEvent, :proposer_id => person.id
        can [:read, :update, :destroy, :accept, :reject], ProposedEvent do |event|
          event.parent && can?(:admin_proposals, event.parent)
        end
        
      end
    end
  end
end