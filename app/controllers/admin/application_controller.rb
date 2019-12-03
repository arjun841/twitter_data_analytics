module Admin
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :authenticate_user!

    layout :layout_by_resource

    def index
    end

    def overall_sentiment_analytics
    end

    def dashboard_count_wrt_date_for_max_retweets
      from_date = Date.today - 25.days
      to_date = Date.today
      range = (from_date..to_date)
      metric = {}
      range.each do |date|
        metric[date.to_s] = {}
        tweet_id_metric = TweetAnalytic.where("DATE(created_at) = ?", date.to_s).order(retweet_count: :desc).first
        if tweet_id_metric
          metric[date.to_s][tweet_id_metric.tweet_id] = tweet_id_metric.retweet_count.to_i
        else
          metric[date.to_s]["NONE"] = 0
        end
      end
      retweet_metric_data = []
      metric.each do |date, value|
        value.each do |tweet_id, count|
          retweet_metric_data << [tweet_id, date, count]
        end
      end
      @analytic_data = retweet_metric_data
    end

    def dashboard_count_wrt_date_for_entity
      from_date = Date.today - 25.days
      to_date = Date.today
      range = (from_date..to_date)
      metric = {}
      range.each do |date|
        date_metric = { "COMMERCIAL_ITEM" => 0, "DATE" => 0, "EVENT" => 0,
                        "LOCATION" => 0, "ORGANIZATION" => 0, "OTHER" =>0,
                        "PERSON" => 0, "QUANTITY" => 0, "TITLE" => 0 }
        per_date_metric = TweetAnalytic.where("DATE(created_at) = ?", date.to_s).group_by(&:entity).inject({}) do |h, (entity, value)|
          h[entity] = value.to_a.collect(&:tweet_id).uniq.count
          h
        end
        date_metric.merge!(per_date_metric)
        date_metric.delete(nil)
        metric[date.to_s] = date_metric
      end
      entity_metric_data = {}
      metric.each do |date, value|
        value.each do |entity, count|
          entity_metric_data[entity.to_s] ||= []
          entity_metric_data[entity.to_s] << [date, count]
        end
      end
      @analytic_data = entity_metric_data
    end

    def dashboard_count_wrt_date_for_sentiment
      from_date = Date.today - 25.days
      to_date = Date.today
      range = (from_date..to_date)
      metric = {}
      range.each do |date|
        date_metric = { "NEUTRAL": 0, "POSITIVE": 0, "NEGATIVE": 0 }
        per_date_metric = TweetAnalytic.where("DATE(created_at) = ?", date.to_s).group_by(&:sentiment).inject({}) do |h, (sentiment, value)|
          h[sentiment] = value.to_a.collect(&:tweet_id).uniq.count
          h
        end
        date_metric.merge!(per_date_metric)
        date_metric.delete(nil)
        metric[date.to_s] = date_metric
      end
      sentiment_metric_data = {}
      metric.each do |date, value|
        value.each do |sentiment, count|
          sentiment_metric_data[sentiment.to_s] ||= []
          sentiment_metric_data[sentiment.to_s] << [date, count]
        end
      end
      @analytic_data = sentiment_metric_data
    end 

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:account_update) do |u|
        u.permit(:password, :password_confirmation, :current_password, :name)
      end
    end

    private def layout_by_resource
      if devise_controller?
        'layouts/devise'
      else
        'admin/layouts/admin'
      end
    end
  end
end
