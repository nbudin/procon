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
  end
end
