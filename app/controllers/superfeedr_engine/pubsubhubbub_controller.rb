require_dependency "superfeedr_engine/application_controller"
require_dependency "superfeedr_engine/request_validator"

module SuperfeedrEngine
  class PubsubhubbubController < ApplicationController

    def notify
      validator = RequestValidator.new(request, params)

      if validator.valid?
        feed = validator.feed

        if feed.method(:notified).arity == 2
          feed.notified(feed_params, request.raw_post)
        else
          feed.notified(feed_params)
        end

      else
        Rails.logger.error(validator.error)
      end

      render :text => "Thanks"
    end

    protected

    def feed_params
      params.delete("pubsubhubbub")
      params.delete("feed_id")
      params
    end
  end
end

