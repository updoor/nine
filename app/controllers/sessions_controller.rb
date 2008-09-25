# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController

  skip_before_filter :login_required
  skip_before_filter :current_user_projects


  # render new.rhtml
  def new
  end

  def create
    self.current_mst_user = MstUser.authenticate(params[:login_id], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        current_mst_user.remember_me unless current_mst_user.remember_token?
        cookies[:auth_token] = { :value => self.current_mst_user.remember_token , :expires => self.current_mst_user.remember_token_expires_at }
      end
      redirect_back_or_default('/')
      flash[:notice] = "Logged in successfully"
    else
      render :action => 'new'
    end
  end

  def destroy
    self.current_mst_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end
end
