require File.dirname(__FILE__) + '/../test_helper'
require 'attendances_controller'

# Re-raise errors caught by the controller.
class AttendancesController; def rescue_action(e) raise e end; end

class AttendancesControllerTest < Test::Unit::TestCase
  fixtures :attendances

  def setup
    @controller = AttendancesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:attendances)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_attendance
    old_count = Attendance.count
    post :create, :attendance => { }
    assert_equal old_count+1, Attendance.count
    
    assert_redirected_to attendance_path(assigns(:attendance))
  end

  def test_should_show_attendance
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_attendance
    put :update, :id => 1, :attendance => { }
    assert_redirected_to attendance_path(assigns(:attendance))
  end
  
  def test_should_destroy_attendance
    old_count = Attendance.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Attendance.count
    
    assert_redirected_to attendances_path
  end
end
