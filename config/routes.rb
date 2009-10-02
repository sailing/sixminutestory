ActionController::Routing::Routes.draw do |map|
  map.resources :contests

  map.resources :prompts
    


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
    
    # site activities
    map.write 'write', :controller => "stories", :action => "new"
    map.write_to_prompt 'write/:prompt', :controller => "stories", :action => "new"
    map.read 'read', :controller => "site", :action => "recent"
    map.past 'archives', :controller => "prompts", :action => "past"
    
    #user activities
    map.login 'login', :controller => "user_sessions", :action => "new"
    map.logout 'logout', :controller => "user_sessions", :action => "destroy"
    map.register 'register', :controller => "users", :action => "new"
    
    #administration
    map.prompts_admin "admin/prompts", :controller => "prompts", :action => "admin"
    map.users_admin "admin/users", :controller => "users", :action => "admin"
    map.stories_admin "admin/stories", :controller => "stories", :action => "admin"
    map.contests_admin "admin/contests", :controller => "contests", :action => "admin"
    map.tags 'tags/:name', :controller => "tags", :action => "show"


    map.resources :users do |user|
       user.resources :votes
       user.resources :stories do |story|
         story.resources :votes
       end
     end

     map.resources :stories do |story|
       story.resources :votes
     end
     
     map.resources :comments
     map.resources :tags

     map.resource :user_session
     
     map.resource :account, :controller => "users"
     
     
    map.with_options :controller => "site" do |site|
      site.root                                   :action => "recent" 
      site.formatted_root     '/recent.:format',  :action => "recent"
      site.search             '/search',          :action => "search"
      site.recent             '/recent',          :action => "recent"
      site.top                '/top',             :action => "top"
      site.formatted_top      '/top.:format',     :action => "top"
      site.browse_by_tags     '/cloud',           :action => "browse_by_tags"
      site.wtf                '/wtf',             :action => "wtf" 
      site.about              '/about',           :action => "about"
      site.contact            '/contact',         :action => "contact"
      site.terms              '/terms',           :action => "terms"
      site.privacy            '/privacy',         :action => "privacy"
      site.api                '/api',             :action => "api"
      site.profile            '/profile/:login',   :action => "profile"
      site.admin              '/admin/',          :action => "admin"
    end


    
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
