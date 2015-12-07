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
		match '/write/random', :to => "prompts#random", :as => 'random_prompt'
    match 'write/:prompt', :to => "stories#new", :as => 'write_to_prompt'
  #   match 'archives', :to => "prompts#index", :as => 'archives'
    match 'thanks/:id', :to => "stories#thanks_for_writing", :as => 'thanks_for_writing'


    resources :prompts do
      resources :votes
      collection do
        get '/:subset', :action => 'index', :constraints => { :subset => /(unverified|scheduled)/ }, :as => "subset"
        get '/suggest', :action => 'new', :as => "suggest"
      end
    end




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
    match 'profile/:user/comments/:time', :to => "comments#index", :as => 'users_comments'
    match 'profile/:user/comments', :to => "comments#index", :as => 'users_comments_sans_time'

    resources :stories do
      resources :votes
      resources :comments
      member do
        post :feature
        post :unfeature
        post :flag
        get :thanks
      end
      
      collection do
        get :random
        get '/:subset(/:tag)', :action => 'index', :constraints => { :subset => /(featured|recent|popular|active|top|genre|adjective|emotion)/, :tag => /.*/ }, :as => 'subset'
        get '/:subset', :action => 'tag_cloud', :constraints => { :subset => /(genres|adjectives|emotions)/ }, :as => 'cloud'
      end
    end

    resources :comments do
      resources :votes
    end

    resources :votes

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
  
  match "/home", :to => "site#index", :as => "site"
  root :to => redirect("/stories/recent")


end
