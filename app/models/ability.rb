class Ability
  include CanCan::Ability
  
  def initialize(person)
    alias_action [:show_description], :to => :read
    
    can :read, Event
    can :read, Schedule, :published => true
        
    if person
      if person.admin?
        can [:read, :create, :update, :destroy, :view_attendees, :admin_schedules, :admin_proposals], Event
        can [:read, :create, :update, :destroy], VirtualSite
        can [:read, :create, :update, :destroy, :health], Schedule
        can [:read, :create, :update, :destroy, :accept, :reject], ProposedEvent
      else
        can [:update, :destroy], Event do |event|
          find_staffers(event, person).any?(&:event_admin?)
        end
        can :view_attendees, Event do |event|
          find_staffers(event, person).any?(&:attendee_viewer?) || (event.attendees_visible && event.all_attendees.include?(person))
        end
        can :admin_schedules, Event do |event|
          find_staffers(event, person).any?(&:schedule_admin?)
        end
        can :admin_proposals, Event do |event|
          find_staffers(event, person).any?(&:proposal_admin?)
        end
        
        can :read, Schedule do |schedule|
          schedule.published? || can?(:admin_schedules, schedule.event)
        end
        can [:create, :update, :destroy], Schedule do |schedule|
          can?(:admin_schedules, schedule.event)
        end
        can :health, Schedule do |schedule|
          can?(:view_attendees, schedule.event)
        end
        
        can :create, ProposedEvent
        can [:read, :update, :destroy], ProposedEvent do |proposal|
          proposal.proposer == person || can?(:admin_proposals, proposal.try(:parent))
        end
        can [:accept, :reject], ProposedEvent do |proposal|
          can?(:admin_proposals, proposal.try(:parent))
        end
        
      end
    end
  end
  
  private
  def find_staffers(event, person)
    Staffer.in_event_and_ancestors(event).where(:person_id => person.id)
  end
end