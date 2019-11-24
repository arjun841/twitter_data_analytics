class TweetAnalytic < ApplicationRecord
	def neutral?
		sentiment == 'NEUTRAL'
	end

	def positive?
		sentiment == 'POSITIVE'
	end

	def negative?
		sentiment == 'NEGATIVE'
	end
end
