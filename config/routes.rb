Sms::Application.routes.draw do
  devise_for :users
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
    get 'write', :to => "stories#new", :as => 'write'
		get '/write/random', :to => "prompts#random", :as => 'random_prompt'
    get 'write/:prompt', :to => "stories#new", :as => 'write_to_prompt'
  #   match 'archives', :to => "prompts#index", :as => 'archives'
    get 'thanks/:id', :to => "stories#thanks_for_writing", :as => 'thanks_for_writing'


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

    get 'addrpxauth', :to => "users#addrpxauth", :as => "addrpxauth"

    get 'profile/:user/favorites', :to => "votes#index", :as => 'favorites'
    get 'profile/:user/comments/:time', :to => "comments#index", :as => 'users_comments'
    get 'profile/:user/comments', :to => "comments#index", :as => 'users_comments_sans_time'

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

    get "/read/:id" => redirect("/stories/%{id}")
    get "/featured/:id" => redirect("/stories/%{id}")
    get "/archives" => redirect("/prompts")

    get "login", :to => 'user_sessions#new', :as => :login
    delete "logout", :to => 'user_sessions#destroy', :as => :logout
    resource :user_session, :path_names => { :new => 'login' }

    get '/recent' => redirect("/stories/recent")
    get '/popular' => redirect("/stories/popular")
    get '/active' => redirect("/stories/active")
    get '/top' => redirect("/stories/top")
    get '/featured'   => redirect("/stories/featured")

    get '/tags'   => redirect("/stories/adjectives")
    get '/genres'       => redirect("/stories/genres")
    get '/emotions'   => redirect("/stories/emotions")

    get                  '/tag/:tag'   => redirect("/stories/adjective/:tag")
    get                 '/genre/:tag'    => redirect("/stories/genre/:tag")
    get               '/emotion/:tag'   => redirect("/stories/emotion/:tag")

#      match search             '/search'          :to => "site#search", :as => 'search'
  get '/faq', :to => "site#faq", :as => 'faq'
  get '/join', :to => "users#new", :as => 'join'

#      match about              '/about'           :to => "site#about", :as => ''
#      match contact            '/contact'         :to => "site#contact", :as => ''
#      match terms              '/terms'           :to => "site#terms", :as => ''
#      match privacy            '/privacy'         :to => "site#privacy", :as => 'privacy'
#      match   '/acknowledgements', :to => "site#acknowledgements", :as => 'acknowledgements'
  
  get "/home", :to => "site#index", :as => "site"
  root :to => redirect("/stories/recent")


end
