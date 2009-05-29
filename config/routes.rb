ActionController::Routing::Routes.draw do |map|

  map.root :controller => "shares"
  map.connect '', :controller => "shares"

  map.tags 'tags/:name', :controller => "tags", :action => "show"
  map.browse_by_tags 'tags', :controller => "tags", :action => "index" 
  
  map.top 'top', :controller => "shares", :action => "top"
  
  map.recent 'recent', :controller => "shares", :action => "recent"
  
  map.resources :users do |user|
    user.resources :votes
    user.resources :shares do |share|
      share.resources :votes
    end
  end

  map.resources :shares do |share|
    share.resources :votes
  end

  map.resources :comments
  map.resources :tags

  
  map.resource :account, :controller => "users"
  map.resource :user_session

 


  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

    map.login 'login', :controller => "user_sessions", :action => "new"
    map.logout 'logout', :controller => "user_sessions", :action => "destroy"
    map.register 'register', :controller => "users", :action => "new"


    map.search 'search',:controller => "shares", :action => "search"

    map.profile '/:login', :controller => "users", :action => "profile"
    map.profile 'profile/:id', :controller => "users", :action => "profile"


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
 
  map.catch_all "*", :controller => "shares"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
