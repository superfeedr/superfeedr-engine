require 'digest/hmac'
require_dependency "superfeedr_engine/application_controller"

module SuperfeedrEngine
  class PubsubhubbubController < ApplicationController

  	def index
  		render :text => "Welcome!"
  	end

  	def notify
  		signature = request.headers['HTTP_X_HUB_SIGNATURE']
  		if !signature
  			Rails.logger.error("Missing signature. Ignored payload for #{params[:feed_id]}. Use retrieve if missing.")
  		else
      	algo, hash = signature.split('=')
      	if algo != "sha1"
      		Rails.logger.error("Unknown signature mechanism. Ignored paylod for #{params[:feed_id]}. Use retrieve if missing.")
      	else
      		feed = feed_klass.find(params[:feed_id])
      		if !feed
	      		Rails.logger.error("Unknown notification for #{params[:feed_id]}.")
	      	else
      			computed = Digest::HMAC.hexdigest(request.raw_post, feed.secret, Digest::SHA1) 
      			if computed == hash      				
      				feed.notified(params)
      			else
      				Rails.logger.error("Non matching signature. Ignored paylod for #{params[:feed_id]}. Use retrieve if missing.")
      			end
	      	end
      	end
      end
      render :text => "Thanks"
  	end

  	protected

  	def feed_klass
  		SuperfeedrEngine::Engine.feed_class.constantize
  	end

  end
end
