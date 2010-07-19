require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def assert_can(ability, actions, object=nil)
    actions = [actions] unless actions.respond_to?(:[])
    
    actions.each do |action|
      assert ability.can?(action, object), "Admin user cannot #{action} a #{object.class.name}"
    end
  end
  
  context "an admin" do
    setup do
      @person = Factory.create(:person, :admin => true)
      @ability = Ability.new(@person)
      
      assert @person.admin?
    end
    
    should "be permitted to admin everything" do      
      e = Factory.create(:event)
      assert_can(@ability, %w{read create update destroy view_attendees}, e)
      
      vs = Factory.create(:virtual_site)
      assert_can(@ability, %w{read create update destroy}, vs)
      
      s = e.schedules.create
      assert_can(@abiilty, %w{read create update destroy health}, s)
      
      pe = Factory.create(:proposal)
      assert_can(@ability, %w{read create update destroy accept reject}, pe)
    end
  end
end
