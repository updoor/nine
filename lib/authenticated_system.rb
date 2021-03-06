module AuthenticatedSystem
  protected
    # Returns true or false if the mst_user is logged in.
    # Preloads @current_mst_user with the mst_user model if they're logged in.
    def logged_in?
      !!current_mst_user
    end

    # Accesses the current mst_user from the session. 
    # Future calls avoid the database because nil is not equal to false.
    def current_mst_user
      @current_mst_user ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_mst_user == false
    end

    # Store the given mst_user id in the session.
    def current_mst_user=(new_mst_user)
      session[:mst_user_id] = new_mst_user ? new_mst_user.id : nil
      @current_mst_user = new_mst_user || false
    end

    # Check if the mst_user is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the mst_user
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_mst_user.login != "bob"
    #  end
    def authorized?
      logged_in?
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      authorized? || access_denied
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the mst_user is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |format|
        format.html do
          store_location
          redirect_to new_session_path
        end
        format.any do
          request_http_basic_authentication 'Web Password'
        end
      end
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.request_uri
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_mst_user and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_mst_user, :logged_in?
    end

    # Called from #current_mst_user.  First attempt to login by the mst_user id stored in the session.
    def login_from_session
      self.current_mst_user = MstUser.find_by_id(session[:mst_user_id]) if session[:mst_user_id]
    end

    # Called from #current_mst_user.  Now, attempt to login by basic authentication information.
    def login_from_basic_auth
      authenticate_with_http_basic do |username, password|
        self.current_mst_user = MstUser.authenticate(username, password)
      end
    end

    # Called from #current_mst_user.  Finaly, attempt to login by an expiring token in the cookie.
    def login_from_cookie
      mst_user = cookies[:auth_token] && MstUser.find_by_remember_token(cookies[:auth_token])
      if mst_user && mst_user.remember_token?
        cookies[:auth_token] = { :value => mst_user.remember_token, :expires => mst_user.remember_token_expires_at }
        self.current_mst_user = mst_user
      end
    end
end
