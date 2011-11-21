Cri::Application.routes.draw do

  # Redir all non-www to www
  constraints(:host => /^childrefugeinternational.org$/) do
    root :to => redirect("http://www.childrefugeinternational.org")
    match '/*path', :to => redirect {|params| "http://www.childrefugeinternational.org/#{params[:path]}"}
  end

  root :to => 'single#homepage'
  match '/donate', :as => :donate, :to => 'single#donate'
  match '/why-give', :as => :why_give, :to => 'single#why_give'
  match '/mission-statement', :as => :mission_statement, :to => 'single#mission_statement'
  match '/frequently-asked-questions', :as => :faq, :to => 'single#faq'
  match '/privacy-policy', :as => :privacy_policy, :to => 'single#privacy_policy'
  # match '/resources', :as => :resources, :to => 'single#resources'

  # # TODO -- younker [2011-11-19 02:35]
  # Fix the fact we now need 'resources' for all user actions, not just sign up
  resources :users
  resource :users
  get "sign_up" => "users#new", :as => "sign_up"


  resource :sessions
  get "login"  => "sessions#new", :as => "login"
  get "logout" => "sessions#destroy", :as => "logout"

  ##
  ## Team Engine Routes
  ##
  mount Team::Engine => "/board-of-directors", :as => :team_engine

  ##
  ## Blog Engine Routes
  ##
  mount Blog::Engine => "/blog", :as => :blog_engine

  match "/news", :as => :news_seo, :to => 'blog/blogs#index'
  resources 'n', :as => :news, :controller => 'blog/blogs'  

  match "/projects", :as => :projects_seo, :to => 'blog/blogs#index'
  resources 'p', :as => :projects, :controller => 'blog/blogs'

end
