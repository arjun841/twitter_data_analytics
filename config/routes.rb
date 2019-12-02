Rails.application.routes.draw do
  # Back admin routes start
  namespace :admin do
    resources :users
    resources :tweet_analytics

    # Admin root
    root to: 'application#index'
  end
  # Back admin routes end

  # Front routes start
  devise_for :users, only: [:session, :registration], path: 'session',
             path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  # Application root
  root to: 'application#home'
  namespace :api do
    get :test, controller: :dashboard, action: :test
    get :count_wrt_sentiment, controller: :dashboard, action: :count_wrt_sentiment
  end 
  # Front routes end
end
