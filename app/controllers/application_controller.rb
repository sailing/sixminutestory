# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :check_for_maintenance 
  before_filter :require_username, :except => [:edit, :update, :create]

  filter_parameter_logging :password, :password_confirmation, :fb_sig_friends
  helper_method :current_user_session, :current_user
  
  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

    private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
       return @current_user if defined?(@current_user)
       @current_user = current_user_session && current_user_session.record
    end
  
    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page."
        redirect_to login_url
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

    def store_location
      session[:return_to] =
      if request.get?
        request.request_uri
      else
        request.referer
      end
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
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
        if !@story.user == current_user && !current_user.admin_level > 1 
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
              redirect_to login_url
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
         if File.exist? "#{RAILS_ROOT}/public/maintenance.html"
           return render( :file =>  "#{RAILS_ROOT}/public/maintenance.html") unless (current_user && current_user.is_admin?)
        end
     end
     
     def rand_with_range(values = nil)
         if values.respond_to? :sort_by
           values.sort_by { rand }.first
         else
           rand(values)
         end
       end

       def get_random()
          model = params[:controller].singularize.classify.constantize
          name = params[:controller].singularize
          
          if (name == "prompt")
            @count = model.count :conditions => ["use_on <= :today", {:today => Date.today} ]
            # choose a record to select
              @get_this = rand_with_range(1..@count)

            # try to get it
              instance_variable_set("@#{name}", model.find(@get_this, :conditions => ["active = :active AND (use_on <= :today)", {:active => true, :today => Date.today} ]))
            
          
          else            
            # count model to get a set to choose among
            @count = model.count
            
            # choose a record to select
              @get_this = rand_with_range(1..@count)

            # try to get it
              instance_variable_set("@#{name}", model.find(@get_this, :conditions => {:active => true}))
            
          end
            
        end # end get_random
        
        # This tests to see if the current user is 
        # following the writer whose story or profile they're viewing.
        def following_exists
          if current_user
            unless @following = current_user.followings.find_by_writer_id(@user.id)
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
