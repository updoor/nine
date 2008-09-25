require File.dirname(__FILE__) + '/../test_helper'
require 'mst_users_controller'

# Re-raise errors caught by the controller.
class MstUsersController; def rescue_action(e) raise e end; end

class MstUsersControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :mst_users

  def setup
    @controller = MstUsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'MstUser.count' do
      create_mst_user
      assert_response :redirect
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'MstUser.count' do
      create_mst_user(:email => nil)
      assert assigns(:mst_user).errors.on(:email)
      assert_response :success
    end
  end
  

  

  protected
    def create_mst_user(options = {})
      post :create, :mst_user => {
        :email => 'quire@example.com',
        :user_name => 'quire',
        :company_name => 'i3systems'
      }.merge(options)
    end
end
