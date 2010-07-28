require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def assert_can_or_cannot(person, can, actions, *objects)
    actions = [actions] unless actions.is_a?(Array)
    objects = [nil] if objects.empty?
    ability = Ability.new(person)
    
    actions.each do |action|
      objects.each do |object|
        actually_can = ability.can?(action.to_sym, object)
        if can
          assert actually_can, "Should be able to #{action} a #{object.class.name}, but can't"
        else
          assert !actually_can, "Shouldn't be able to #{action} a #{object.class.name}, but can"
        end
      end
    end
  end

  def assert_can(person, actions, *objects)
    assert_can_or_cannot(person, true, actions, *objects)
  end
  
  def assert_cannot(person, actions, *objects)
    assert_can_or_cannot(person, false, actions, *objects)
  end
  
  def assert_can_only_if(person, actions, *objects, &block)
    assert_cannot(person, actions, *objects)
    yield
    assert_can(person, actions, *objects)
  end
  
  context "a regular person" do
    setup do
      @person = Factory.create(:person)
    end
    
    should "be able to read events and published schedules" do
      event = Factory.create(:event)
      assert_can(@person, :read, event)
      
      schedule = event.schedules.create
      assert_can_only_if(@person, :read, schedule) do
        schedule.published = true
        schedule.save
      end
    end
    
    should "be able to propose events" do
      assert_can(@person, :create, ProposedEvent)
    end
    
    should "be forbidden to admin anything" do
      e = Factory.create(:event)
      assert_cannot(@person, %w{create update destroy view_attendees admin_schedules admin_proposals}, e)
      
      vs = Factory.create(:virtual_site)
      assert_cannot(@person, %w{read create update destroy}, vs)
      
      s = e.schedules.create
      assert_cannot(@person, %w{create update destroy health}, s)
      
      pe = Factory.create(:proposal)
      assert_cannot(@person, %w{read update destroy accept reject}, pe)
    end
  end
  
  context "an event proposer" do
    setup do
      @person = Factory.create(:person)
      @proposal = Factory.create(:proposal, :proposer => @person)
    end
    
    should "be able to admin the proposal but not decide on it" do
      assert_can(@person, %w{read create update destroy}, @proposal)
      assert_cannot(@person, %{accept reject}, @proposal)
    end
  end
  
  context "an admin" do
    setup do
      @person = Factory.create(:person, :admin => true)      
      assert @person.admin?
    end
    
    should "be permitted to admin everything" do      
      e = Factory.create(:event)
      assert_can(@person, %w{read create update destroy view_attendees admin_schedules admin_proposals}, e)
      
      vs = Factory.create(:virtual_site)
      assert_can(@person, %w{read create update destroy}, vs)
      
      s = e.schedules.create
      assert_can(@person, %w{read create update destroy health}, s)
      
      pe = Factory.create(:proposal)
      assert_can(@person, %w{read create update destroy accept reject}, pe)
    end
  end
  
  context "an event staffer" do
    setup do
      @person = Factory.create(:person)
      @event = Factory.create(:event)
      @child = Factory.create(:event, :parent => @event)
      @staffer = @event.staffers.create(:person => @person)
      
      [@event, @child].each do |event|
        assert Staffer.in_event_and_ancestors(event).include?(@staffer)
      end
    end
    
    should "be able to read the event and child events" do
      assert_can(@person, :read, @event, @child)
    end
    
    should "be able to edit the event and child events only if they're an event admin" do
      assert_can_only_if(@person, %w{update destroy}, @event, @child) do
        @staffer.event_admin = true
        @staffer.save
      end
    end
    
    should "be able to view attendees only if they're an attendee viewer" do
      assert_can_only_if(@person, :view_attendees, @event, @child) do
        @staffer.attendee_viewer = true
        @staffer.save
      end
    end
    
    should "be able to admin event schedules only if they're a schedule admin" do
      assert_can_only_if(@person, :admin_schedules, @event, @child) do
        @staffer.schedule_admin = true
        @staffer.save
      end
    end
    
    should "be able to admin schedules only if they're a schedule admin on an owning event" do
      schedule1 = @event.schedules.create
      schedule2 = @child.schedules.create
      assert_can_only_if(@person, %w{read create update destroy}, schedule1, schedule2) do
        @staffer.schedule_admin = true
        @staffer.save
      end
    end
    
    should "be able to view event health only if they're an attendee viewer on an owning event" do
      schedule1 = @event.schedules.create
      schedule2 = @child.schedules.create
      assert_can_only_if(@person, :health, schedule1, schedule2) do
        @staffer.attendee_viewer = true
        @staffer.save
      end
    end
    
    should "be able to admin event proposals only if they're a proposal admin" do
      assert_can_only_if(@person, :admin_proposals, @event, @child) do
        @staffer.proposal_admin = true
        @staffer.save
      end
    end
    
    should "be able to admin proposals only if they're a proposal admin on an owning event" do
      proposal1 = Factory.create(:proposal, :parent => @event)
      proposal2 = Factory.create(:proposal, :parent => @child)
      assert_can_only_if(@person, %w{read update destroy accept reject}, proposal1, proposal2) do
        @staffer.proposal_admin = true
        @staffer.save
      end
    end
  end
end
