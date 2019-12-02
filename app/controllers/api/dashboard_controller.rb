module Api
	class DashboardController < BaseController
		before_action :required_pagination, only: [:count_wrt_date_for_sentiment,
												   :count_wrt_date_for_entity,
												   :count_wrt_date_for_max_retweets,
												   :count_wrt_date_for_max_replies]
		before_action :required_from_to_date, only: [:count_wrt_date_for_sentiment,
												     :count_wrt_date_for_entity,
												     :count_wrt_date_for_max_retweets,
												     :count_wrt_date_for_max_replies]

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

		def count_wrt_date_for_entity
			to_date = params[:to_date]
			from_date = params[:from_date]
			offset = params[:page].to_i * params[:per].to_i
			limit = params[:per].to_i
			range = (Date.parse(from_date)..Date.parse(to_date)).to_a[offset, limit]
			metric = {}
			range.each do |date|
				date_metric = { "COMMERCIAL_ITEM": 0, "DATE": 0, "EVENT": 0,
								"LOCATION": 0, "ORGANIZATION": 0, "OTHER": 0,
								"PERSON": 0, "QUANTITY": 0, "TITLE": 0 }
				per_date_metric = TweetAnalytic.where("DATE(created_at) = ?", date.to_s).group_by(&:entity).inject({}) do |h, (entity, value)|
			 		h[entity] = value.to_a.collect(&:tweet_id).uniq.count
			 		h
			 	end
			 	date_metric.merge!(per_date_metric)
			 	date_metric.delete(nil)
			 	metric[date.to_s] = date_metric
			end
			render json: { metric: metric }
		end

		def count_wrt_date_for_sentiment
			to_date = params[:to_date]
			from_date = params[:from_date]
			offset = params[:page].to_i * params[:per].to_i
			limit = params[:per].to_i
			range = (Date.parse(from_date)..Date.parse(to_date)).to_a[offset, limit]
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
			render json: { metric: metric }
		end

		def count_wrt_date_for_max_retweets
			to_date = params[:to_date]
			from_date = params[:from_date]
			offset = params[:page].to_i * params[:per].to_i
			limit = params[:per].to_i
			range = (Date.parse(from_date)..Date.parse(to_date)).to_a[offset, limit]
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
			render json: { metric: metric }
		end

		def count_wrt_date_for_max_replies
			to_date = params[:to_date]
			from_date = params[:from_date]
			offset = params[:page].to_i * params[:per].to_i
			limit = params[:per].to_i
			range = (Date.parse(from_date)..Date.parse(to_date)).to_a[offset, limit]
			metric = {}
			range.each do |date|
				metric[date.to_s] = {}
				per_date_metric = TweetAnalytic.where("DATE(created_at) = ?", date.to_s)
											   .group_by(&:replied_to_tweet_id)
											   .inject({}) do |h, (replied_to_tweet_id, value)|
			 		h[replied_to_tweet_id] = value.to_a.collect(&:tweet_id).uniq.count
			 		h
			 	end
			 	per_date_metric.delete(nil)
			 	max_val_key = "NONE"
			 	max_val = 0
			 	per_date_metric.each do |key, value|
			 		if key != "" && value > max_val
			 			max_val = value
			 			max_val_key = key
			 		end
			 	end
			 	metric[date.to_s][max_val_key] = max_val
			end
			render json: { metric: metric }
		end

		def sentiment_wrt_location
		end

		private

			def required_pagination
				raise Api::Err::InvalidPagination unless (params[:page] && params[:per])
			end

			def required_from_to_date
				to_date = params[:to_date]
				from_date = params[:from_date]
				raise Api::Err::InvalidDateRange unless (to_date && from_date)
				begin Date.parse(from_date)
					begin Date.parse(from_date)
					rescue => e
						raise Api::Err::InvalidDate
					end
				rescue => e
					raise Api::Err::InvalidDate
				end
			end
	end
end
