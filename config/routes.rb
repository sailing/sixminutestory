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
     match 'archives', :to => "prompts#index", :as => 'archives'
     match 'prompts/suggest', :to => "prompts#new", :as => 'suggest_a_prompt'
     match 'thanks/:id', :to => "stories#thanks_for_writing", :as => 'thanks_for_writing'
      # reading
            
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
          end
     end
     
    resources :comments
     
     match "/read/:id" => redirect("/stories/%{id}")
      
      resources :prompts
        
        match "login", :to => 'user_sessions#new', :as => :login
         match "logout", :to => 'user_sessions#destroy', :as => :logout
      resource :user_session, :path_names => { :new => 'login' }
      
      match '/recent', :to => "stories#index", :as => 'recent'
      match '/popular', :to => "stories#index", :as => 'popular'
      match '/active', :to => "stories#index", :as => 'commented'
      match '/top', :to => "stories#index", :as => 'top'
      
       match             '/featured', :to => "stories#show", :as => 'featured'  
       match     '/featured.:format', :to => "stories#show", :as => 'formatted_featured'
     
     
      match     '/tags', :to => "stories#tag_cloud", :as => 'browse_by_tags'
      match     '/genres',    :to => "stories#tag_cloud", :as => 'browse_by_genres'
      match '/emotions',   :to => "stories#tag_cloud", :as => 'browse_by_emotions'
     
      match                  '/tag/:tag', :to => "stories#index", :constraints => { :tag => /.*/ }, :as => 'tag'
      match                 '/genre/:tag', :to => "stories#index", :constraints => { :tag => /.*/ }, :as => 'genre'
      match               '/emotion/:tag', :to => "stories#index", :constraints => { :tag => /.*/ }, :as => 'emotion'
     
#      match search             '/search'          :to => "site#search", :as => 'search' 
      match '/faq', :to => "site#faq", :as => 'faq'
#      match about              '/about'           :to => "site#about", :as => ''
#      match contact            '/contact'         :to => "site#contact", :as => ''
#      match terms              '/terms'           :to => "site#terms", :as => ''
#      match privacy            '/privacy'         :to => "site#privacy", :as => 'privacy'
#      match   '/acknowledgements', :to => "site#acknowledgements", :as => 'acknowledgements'
    
     root :to => "stories#show"
    
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
