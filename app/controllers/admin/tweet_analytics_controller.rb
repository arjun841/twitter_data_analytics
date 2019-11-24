module Admin
	class TweetAnalyticsController < Admin::ApplicationController
		respond_to :json, :html
		def index
			@q = TweetAnalytic.ransack(params[:q])
		 	@tweet_analytics_data = @q.result.order(:tweet_id).page(params[:page]).per(10)
		end
	end
end