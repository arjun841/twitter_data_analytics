Rails.application.routes.draw do
  # Back admin routes start
  namespace :admin do
    resources :users
    resources :tweet_analytics

    # Admin root
    root to: 'application#dashboard_count_wrt_date_for_entity'
    get :sentiment_wrt_location, controller: :application, action: :index
    get :dashboard_count_wrt_date_for_entity, controller: :application, action: :dashboard_count_wrt_date_for_entity
    get :dashboard_count_wrt_date_for_sentiment, controller: :application, action: :dashboard_count_wrt_date_for_sentiment
    get :dashboard_count_wrt_date_for_max_retweets, controller: :application, action: :dashboard_count_wrt_date_for_max_retweets
    get :overall_sentiment_analytics, controller: :application, action: :overall_sentiment_analytics
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
    get :count_wrt_date_for_entity, controller: :dashboard, action: :count_wrt_date_for_entity
    get :count_wrt_date_for_sentiment, controller: :dashboard, action: :count_wrt_date_for_sentiment
    get :count_wrt_date_for_max_retweets, controller: :dashboard, action: :count_wrt_date_for_max_retweets
    get :count_wrt_date_for_max_replies, controller: :dashboard, action: :count_wrt_date_for_max_replies
    get :sentiment_wrt_location, controller: :dashboard, action: :sentiment_wrt_location
  end 
  # Front routes end
end
