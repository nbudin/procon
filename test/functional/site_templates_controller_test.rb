require 'test_helper'

class SiteTemplatesControllerTest < ActionController::TestCase
  fixtures :site_templates

  def setup
    @controller = SiteTemplatesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:site_templates)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_site_template
    old_count = SiteTemplate.count
    post :create, :site_template => { }
    assert_equal old_count+1, SiteTemplate.count
    
    assert_redirected_to site_template_path(assigns(:site_template))
  end

  def test_should_show_site_template
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_site_template
    put :update, :id => 1, :site_template => { }
    assert_redirected_to site_template_path(assigns(:site_template))
  end
  
  def test_should_destroy_site_template
    old_count = SiteTemplate.count
    delete :destroy, :id => 1
    assert_equal old_count-1, SiteTemplate.count
    
    assert_redirected_to site_templates_path
  end
end
