require 'test_helper'

class ProposedEventsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proposed_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proposed_event" do
    assert_difference('ProposedEvent.count') do
      post :create, :proposed_event => { }
    end

    assert_redirected_to proposed_event_path(assigns(:proposed_event))
  end

  test "should show proposed_event" do
    get :show, :id => proposed_events(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => proposed_events(:one).to_param
    assert_response :success
  end

  test "should update proposed_event" do
    put :update, :id => proposed_events(:one).to_param, :proposed_event => { }
    assert_redirected_to proposed_event_path(assigns(:proposed_event))
  end

  test "should destroy proposed_event" do
    assert_difference('ProposedEvent.count', -1) do
      delete :destroy, :id => proposed_events(:one).to_param
    end

    assert_redirected_to proposed_events_path
  end
end
