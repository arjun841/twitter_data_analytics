class CreateTweetAnalytics < ActiveRecord::Migration[5.0]
  def change
    create_table :tweet_analytics do |t|
      t.string, :tweet_id
      t.string :text
      t.string :translated_text
      t.string :language
      t.string :sentiment
      t.string :tweet_location
      t.string :entity
      t.string :replied_to_tweet_id
      t.string :sentiment_neutral_score
      t.string :sentiment_positive_score
      t.string :sentiment_negative_score
      t.string :sentiment_mixed_score
      t.timestamps
    end
  end
end
