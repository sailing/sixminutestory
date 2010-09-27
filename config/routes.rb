ActionController::Routing::Routes.draw do |map|

  map.resources :followings

#  map.resources :contests



  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
    
    # site activities
      # writing / prompts
    map.write 'write', :controller => "stories", :action => "new"
    map.write_random 'random/write', :controller => "prompts", :action => "random"
    map.write_to_prompt 'write/:prompt', :controller => "stories", :action => "new"
    map.past_prompts 'archives', :controller => "prompts", :action => "index"
    map.suggest_a_prompt 'prompts/suggest', :controller => "prompts", :action => "new"
    map.thanks 'thanks/:id', :controller => "stories", :action => "thanks_for_writing"
      # reading

    map.read_random 'random', :controller => "stories", :action => "random"
    map.flag_story 'flag', :controller => "stories", :action => "flag_story", :conditions => { :method => :post }
    #map.rss 'rss/:id', :controller => "users", :action => "show"
    
    #user activities
    map.login 'login', :controller => "user_sessions", :action => "new"
    map.logout 'logout', :controller => "user_sessions", :action => "destroy"
    map.register 'register', :controller => "users", :action => "new"
     map.addrpxauth "addrpxauth", :controller => "users", :action => "addrpxauth", :method => :post
    
  #  map.profile            '/profile/:login', :controller => "users", :action => "show", :requirements => {:login => /.*/}
  #  map.formatted_profile '/profile/:id.:format', :controller => "users", :action => "show"
  #  map.formatted_profile_personal '/profile/personal/:id.:format', :controller => "users", :action => "show"
    
    #administration
    map.unverified_prompts "/prompts/unverified", :controller => "prompts", :action => "index" 
    map.users_admin "admin/users", :controller => "users", :action => "admin"
    map.stories_admin "admin/stories", :controller => "stories", :action => "admin"
    map.disabled_stories "admin/stories/disabled", :controller => "stories", :action => "disabled"
    map.enable_story "admin/stories/enable/:id", :controller => "stories", :action => "enable_story"
    map.disable_story "admin/stories/disable/:id", :controller => "stories", :action => "disable_story"
    map.feature_story "admin/stories/feature/:id", :controller => "stories", :action => "feature_story"
    map.unfeature_story "admin/stories/unfeature/:id", :controller => "stories", :action => "unfeature_story"
    map.enable_user "admin/users/enable/:id", :controller => "users", :action => "enable_user"
     map.disable_user "admin/users/disable/:id", :controller => "users", :action => "disable_user"
    map.contests_admin "admin/contests", :controller => "contests", :action => "admin"
    


    map.resources :users do |user|
       user.resources :votes
       user.resources :stories do |story|
         story.resources :votes
       end
     end
     
   map.resource :account, :controller => "users"
   map.resources :profile, :controller => "users"
 
     map.resources :stories do |story|
       story.resources :votes
     end
     
       map.resources :prompts
        
     map.resources :comments

     map.resource :user_session

     map.with_options :controller => "stories", :action => "show" do |story|     
 
       story.read_story             'read/:id'
       story.read_featured_story    'featured/:id'
       story.featured             '/featured'     
       story.formatted_featured     '/featured.:format'
     
     end
     map.resources :read, :controller => "stories"
     map.browse_by_tags     '/tags',     :controller => "stories",      :action => "tag_cloud"
     
     
     
     map.with_options :controller => "stories", :action => "index" do |story|     
       story.read                 '/recent'

       story.recent               '/recent'          
       story.formatted_recent     '/recent.:format'
       story.popular              '/popular'
       story.formatted_popular     '/popular.:format'
       story.commented            '/commented'
       story.formatted_commented     '/commented.:format'
       story.top                  '/top'
       story.formatted_top        '/top.:format'
       story.tag                  '/tag/:tag', :requirements => { :tag => /.*/ }
     end
     
    map.with_options :controller => "site" do |site| 
      site.search             '/search',          :action => "search"
      site.faq                '/faq',             :action => "faq" 
      site.about              '/about',           :action => "about"
      site.contact            '/contact',         :action => "contact"
      site.terms              '/terms',           :action => "terms"
      site.privacy            '/privacy',         :action => "privacy"
      site.api                '/api',             :action => "api"
      site.admin              '/admin',          :action => "admin"
      site.acknowledgements   '/acknowledgements', :action => "acknowledgements"
    end

    map.root              :controller => "stories",     :action => "show"
    map.formatted_root     '/featured.:format', :controller => "stories",  :action => "index"
    
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products


  

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  
 
  map.catch_all "*", :controller => "stories"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
