module Api
	class DashboardController < BaseController

		def test
			render json: { message: "nicely done!" }
		end

		def count_wrt_sentiment
			metric = TweetAnalytic.select(:sentiment, :tweet_id).all.group_by(&:sentiment).inject({}) do |h, (sentiment, value)|
					 	h[sentiment] = value.to_a.collect(&:tweet_id).uniq.count
					 	h
					 end
	 		metric.delete(nil)
			render json: { metric: metric }
		end

	end
end
