require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:schedules)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_schedule
    assert_difference('Schedule.count') do
      post :create, :schedule => { }
    end

    assert_redirected_to schedule_path(assigns(:schedule))
  end

  def test_should_show_schedule
    get :show, :id => schedules(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => schedules(:one).id
    assert_response :success
  end

  def test_should_update_schedule
    put :update, :id => schedules(:one).id, :schedule => { }
    assert_redirected_to schedule_path(assigns(:schedule))
  end

  def test_should_destroy_schedule
    assert_difference('Schedule.count', -1) do
      delete :destroy, :id => schedules(:one).id
    end

    assert_redirected_to schedules_path
  end
end
