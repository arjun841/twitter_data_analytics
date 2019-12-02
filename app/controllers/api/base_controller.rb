module Api
	class BaseController < ActionController::Base
		before_action :verify_token
		rescue_from ActiveRecord::RecordNotFound do
		    respond_to do |format|
		      format.json { render json: { message: "Invalid Token" }, status: 403 }
		    end
	  	end

		private

			def verify_token
				raise ActiveRecord::RecordNotFound unless User.exists?(token: request.headers[:token])
			end
	end
end
