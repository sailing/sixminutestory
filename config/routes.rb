Sms::Application.routes.draw do
#  resources :products do
#    resource :category

#    member do
#      post :short
#    end

#    collection do
#      get :long
#    end
#  end

#  match "/posts/github" => redirect("http://github.com/rails.atom")

  
   resources :followings

#   resources :contests do
#     resources :stories
#   end 
    



  # The priority is based upon order of creation: first created -> highest priority.
 

    
    # site activities
      # writing / prompts
     match 'write', :to => "stories#new", :as => 'write'
     match 'write/:prompt', :to => "stories#new", :as => 'write_to_prompt'
  #   match 'archives', :to => "prompts#index", :as => 'archives'
     match 'prompts/suggest', :to => "prompts#new", :as => 'suggest_a_prompt'
     match 'thanks/:id', :to => "stories#thanks_for_writing", :as => 'thanks_for_writing'
                  resources :prompts
    #administration
     match "/archives/unverified", :to => "prompts#index", :as => 'unverified_prompts'
     match "/archives/scheduled", :to => "prompts#index", :as => 'scheduled_prompts'

    


     resources :users, :path_names => { :new => 'register' } do
       resources :votes
       resources :stories do
         resources :votes
       end
       resources :comments
       resources :prompts
       resources :followings
       member do
        put :enable
        put :disable
       end
     end
              
     resource :account, :controller => "users"
     resources :profile, :controller => "users"

     match 'addrpxauth', :to => "users#addrpxauth", :as => "addrpxauth"

     match 'profile/:user/favorites', :to => "votes#index", :as => 'favorites'
     match 'account/comments/:time', :to => "comments#index", :as => 'users_comments'
     match 'account/comments', :to => "comments#index", :as => 'users_comments_sans_time'

#     match '/stories(/:subset(/:tag))', :to => "stories#index", :constraints => { :subset => /(featured|recent|popular|active|top|genre|tag|emotion)/, :tag => /.*/ }, :as => 'reading'
     #match     '/stories/:subset.:format', :to => "stories#index", :as => 'formatted_subset'


      resources :stories do
           resources :votes
           resources :comments
           member do
              put :feature
              put :unfeature
              get :thanks
           end
           collection do
               post :flag
               get :random
               get '/:subset(/:tag)', :action => 'index', :constraints => { :subset => /(featured|recent|popular|active|top|genre|adjective|emotion)/, :tag => /.*/ }, :as => 'subset'
               get '/:subset', :action => 'tag_cloud', :constraints => { :subset => /(genres|adjectives|emotions)/ }, :as => 'cloud'
               
          end
     end
    resources :votes
    resources :comments 

     
     match "/read/:id" => redirect("/stories/%{id}")
     match "/featured/:id" => redirect("/stories/%{id}")
     match "/archives" => redirect("/prompts") 
      
 
        
        match "login", :to => 'user_sessions#new', :as => :login
         match "logout", :to => 'user_sessions#destroy', :as => :logout
      resource :user_session, :path_names => { :new => 'login' }
      
      match '/recent' => redirect("/stories/recent")
      match '/popular' => redirect("/stories/popular")
      match '/active' => redirect("/stories/active")
      match '/top' => redirect("/stories/top")
      match '/featured'   => redirect("/stories/featured")
     
      match '/tags'   => redirect("/stories/adjectives")
      match '/genres'       => redirect("/stories/genres")
      match '/emotions'   => redirect("/stories/emotions")
     
     match                  '/tag/:tag'   => redirect("/stories/adjective/:tag")
      match                 '/genre/:tag'    => redirect("/stories/genre/:tag")
      match               '/emotion/:tag'   => redirect("/stories/emotion/:tag")
     
#      match search             '/search'          :to => "site#search", :as => 'search' 
      match '/faq', :to => "site#faq", :as => 'faq'
      match '/join', :to => "users#new", :as => 'join'
#      match about              '/about'           :to => "site#about", :as => ''
#      match contact            '/contact'         :to => "site#contact", :as => ''
#      match terms              '/terms'           :to => "site#terms", :as => ''
#      match privacy            '/privacy'         :to => "site#privacy", :as => 'privacy'
#      match   '/acknowledgements', :to => "site#acknowledgements", :as => 'acknowledgements'
    
     root :to => "stories#index"
    
     # The priority is based upon order of creation:
     # first created -> highest priority.

     # Sample of regular route:
     #   match 'products/:id' => 'catalog#view'
     # Keep in mind you can assign values other than :controller and :action

     # Sample of named route:
     #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
     # This route can be invoked with purchase_url(:id => product.id)

     # Sample resource route (maps HTTP verbs to controller actions automatically):
     #   resources :products

     # Sample resource route with options:
     #   resources :products do
     #     member do
     #       get 'short'
     #       post 'toggle'
     #     end
     #
     #     collection do
     #       get 'sold'
     #     end
     #   end

     # Sample resource route with sub-resources:
     #   resources :products do
     #     resources :comments, :sales
     #     resource :seller
     #   end

     # Sample resource route with more complex sub-resources
     #   resources :products do
     #     resources :comments
     #     resources :sales do
     #       get 'recent', :on => :collection
     #     end
     #   end

     # Sample resource route within a namespace:
     #   namespace :admin do
     #     # Directs /admin/products/* to Admin::ProductsController
     #     # (app/controllers/admin/products_controller.rb)
     #     resources :products
     #   end

     # You can have the root of your site routed with "root"
     # just remember to delete public/index.html.
     # root :to => "welcome#index"

     # See how all your routes lay out with "rake routes"

     # This is a legacy wild controller route that's not recommended for RESTful applications.
     # Note: This route will make all actions in every controller accessible via GET requests.
      #match ':controller(/:action(/:id(.:format)))'
  
end
