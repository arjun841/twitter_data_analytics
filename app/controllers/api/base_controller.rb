module Api
	class Err < StandardError
		class TokenNotFound < Err
		end

		class InvalidPagination < Err
		end

		class InvalidDateRange < Err
		end
	end

	class BaseController < ActionController::Base
		before_action :verify_token
		rescue_from Api::Err::TokenNotFound do
		    respond_to do |format|
		      format.json { render json: { message: "Invalid Token" }, status: 403 }
		    end
	  	end

		private

			def verify_token
				raise Api::Err::TokenNotFound unless User.exists?(token: request.headers[:token])
			end
	end
end
