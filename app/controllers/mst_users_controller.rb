class MstUsersController < ApplicationController
  skip_before_filter :login_required, :only => ['new', 'create']
  skip_before_filter :current_user_projects, :only => ['new', 'create']

  # render new.rhtml
  def new
  end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @mst_user = MstUser.signup(params[:mst_user])
    @mst_user.save
    if @mst_user.errors.empty?
      self.current_mst_user = @mst_user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

  def edit
    @mst_user = MstUser.find(@current_mst_user.id)
    render(:layout => 'application')
  end
end
