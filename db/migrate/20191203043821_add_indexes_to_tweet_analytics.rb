class AddIndexesToTweetAnalytics < ActiveRecord::Migration[5.0]
  def change
  	add_index :tweet_analytics, :tweet_location
  	add_index :tweet_analytics, :tweet_id
  	add_index :tweet_analytics, :sentiment
  	add_index :tweet_analytics, :entity
  	add_index :tweet_analytics, :created_at
  	add_index :tweet_analytics, :replied_to_tweet_id
  	add_index :tweet_analytics, :retweet_count
  	add_index :tweet_analytics, :favourites_count
  end
end
