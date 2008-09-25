# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '5d2ee7214ded9532a406c2a540600317'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  before_filter :login_required
  before_filter :current_user_projects


  def current_user_projects
    @my_projects = @current_mst_user.my_projects
    @my_active_projects = @current_mst_user.my_active_projects
    
    p_id = current_project_code
    @current_project = DatProject.find_by_project_cd(p_id) if p_id
  end

  def current_project_code
    p_id = params[:p_id] ||= params[:id]
  end

  # authenticated override
  def access_denied
    respond_to do |format|
      format.html do
        store_location
        redirect_to '/login'
      end
      format.any do
        request_http_basic_authentication 'Web Password'
      end
    end
  end
end
