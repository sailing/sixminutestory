# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_action :store_user_location!, if: :storable_location?
  # The callback which stores the current location must be added before you authenticate the user 
  # as `authenticate_user!` (or whatever your resource is) will halt the filter chain and redirect 
  # before the location can be stored.

  acts_as_token_authentication_handler_for User
  skip_before_action :authenticate_user_from_token!
  before_action :authenticate_user_from_token!, if: :login_params_present?

  before_action :check_for_maintenance 
  before_action :require_username, :except => [:edit, :update, :create]

  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  private
    def login_params_present?
      params[:user_email].present? && params[:user_token].present?
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page."
        redirect_to new_user_session_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        redirect_to account_url
        return false
      end
    end

    private
      # Its important that the location is NOT stored if:
      # - The request method is not GET (non idempotent)
      # - The request is handled by a Devise controller such as Devise::SessionsController as that could cause an 
      #    infinite redirect loop.
      # - The request is an Ajax request as this can lead to very unexpected behaviour.
      def storable_location?
        request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
      end

      def store_user_location!
        # :user is the scope we are authenticating
        store_location_for(:user, request.fullpath)
      end

      def after_sign_in_path_for(resource_or_scope)
        stored_location_for(resource_or_scope) || super
      end
    
         # Check to see if user is an admin
      def must_be_admin
        (current_user && @current_user.admin_level > 1) || ownership_violation
        return false
      end
    
      def must_own_user
        if current_user
          @user ||= User.find(params[:id])
          @user == @current_user || @current_user.admin_level > 1 || ownership_violation
          return false
        end
      end
    
      def must_own_story
        if current_user
         @story ||= Story.find(params[:id])
          unless @story.user == current_user or current_user.admin_level > 1
            ownership_violation
          end
          return false
        end 
      end

     def ownership_violation
       respond_to do |format|
         flash[:notice] = 'You don\'t have clearance to do that.'
         format.html do
           if current_user
              redirect_to account_url
           else
              redirect_to new_user_session_url
           end
          
          end
       end
     end
     
    def require_username
      if current_user
        unless current_user.login.present?
          flash[:notice] = "Please choose a username to represent you on Six Minute Story."
          redirect_to edit_account_url
        end
      end
    end
     
     
    def check_for_maintenance
      if File.exist? "#{Rails.root}/public/maintenance.html"
         return render( :file =>  "#{Rails.root}/public/maintenance.html") unless (current_user && current_user.is_admin?)
      end
    end

        
    # This tests to see if the current user is 
    # following the writer whose story or profile they're viewing.
    def following_exists(user_id)
      if current_user
        unless @following = current_user.followings.find_by_writer_id(user_id)
          @following = nil
        end
      end
    end      
        
 #       def rescue_action_in_public(exception)
#          case exception
 #           when ActiveRecord::RecordNotFound, ActionController::RoutingError, ActionController::UnknownController, ActionController::UnknownAction
#              render_404
 #           else          
#              render_500
 #         end
  #      end
  
        
        def render_404
          render :template => "site/error_404", :layout => 'application', :status => :not_found
        end
        
        def render_500
          render :template => "site/error_500", :status => :internal_server_error
        end
        
      
end
