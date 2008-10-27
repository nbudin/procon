require File.dirname(__FILE__) + '/../test_helper'
require 'registration_rules_controller'

# Re-raise errors caught by the controller.
class RegistrationRulesController; def rescue_action(e) raise e end; end

class RegistrationRulesControllerTest < Test::Unit::TestCase
  fixtures :registration_rules

  def setup
    @controller = RegistrationRulesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:registration_rules)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_registration_rule
    old_count = RegistrationRule.count
    post :create, :registration_rule => { }
    assert_equal old_count+1, RegistrationRule.count
    
    assert_redirected_to registration_rule_path(assigns(:registration_rule))
  end

  def test_should_show_registration_rule
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_registration_rule
    put :update, :id => 1, :registration_rule => { }
    assert_redirected_to registration_rule_path(assigns(:registration_rule))
  end
  
  def test_should_destroy_registration_rule
    old_count = RegistrationRule.count
    delete :destroy, :id => 1
    assert_equal old_count-1, RegistrationRule.count
    
    assert_redirected_to registration_rules_path
  end
end
