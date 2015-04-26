require 'openssl' 
require_dependency "superfeedr_engine/application_controller"

module SuperfeedrEngine
  class PubsubhubbubController < ApplicationController

    def notify
      signature = request.headers['HTTP_X_HUB_SIGNATURE']
      if !signature
        Rails.logger.error("Missing signature. Ignored payload for #{params[:feed_id]}. Use retrieve if missing.")
      else
        algo, hash = signature.split('=')
        if algo != "sha1"
          Rails.logger.error("Unknown signature mechanism #{algo}. Ignored paylod for #{params[:feed_id]}. Use retrieve if missing.")
        else
          feed = feed_klass.find(params[:feed_id])
          if !feed
            Rails.logger.error("Unknown notification for #{params[:feed_id]}.")
          else
            digest  = OpenSSL::Digest.new(algo)
            computed = OpenSSL::HMAC.hexdigest(digest, feed.secret, request.raw_post)
            if computed == hash
              params.delete("pubsubhubbub")
              if !feed_klass.method_defined?(:notified)
                Rails.logger.error("Please make sure your #{feed_klass} intances have a 'notified' method.")              
              elsif feed.method(:notified).arity == 2
                feed.notified(params, request.raw_post) 
              elsif feed.method(:notified).arity == 1
                feed.notified(params) 
              end
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
