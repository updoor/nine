module AuthenticatedTestHelper
  # Sets the current mst_user in the session from the mst_user fixtures.
  def login_as(mst_user)
    @request.session[:mst_user_id] = mst_user ? mst_users(mst_user).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end
end
