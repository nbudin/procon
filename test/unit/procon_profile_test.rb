require File.dirname(__FILE__) + '/../test_helper'

class ProconProfileTest < ActiveSupport::TestCase
  should_belong_to :person
  
  context "A superadmin's profile" do
    setup do
      @profile = Factory.build(:superadmin_profile)
    end
    
    should "have the superadmin role" do
      assert @profile.has_role?(:superadmin)
    end
  end
  
  context "An event attendee's profile" do
    setup do
      @profile = Factory.build(:attendee_profile)
      assert @profile.events.first.all_attendees.include? @profile.person
    end
    
    should "have the attendee role with respect to its event" do
      assert @profile.has_role?(:attendee, @profile.events.first)
    end
  end
  
  context "An event staffer's profile" do
    setup do
      @profile = Factory.build(:staff_profile)
      assert @profile.events.first.staff.include? @profile.person
    end
    
    should "have the staff role with respect to its event" do
      assert @profile.has_role?(:staff, @profile.events.first)
    end
    
    context "for an event with child events" do
      setup do
        @child = Factory.create(:event, :parent => @profile.events.first)
      end
      
      should "have the staff role with respect to the child event" do
        assert @profile.has_role?(:staff, @child)
      end
    end
  end
  
  context "An event proposer's profile" do
    setup do
      @profile = Factory.build(:proposer_profile)
      assert_equal @profile.person, @profile.proposals.first.proposer
    end
    
    should "have the proposer role with respect to its event" do
      assert @profile.has_role?(:proposer, @profile.proposals.first)
    end
  end
end
