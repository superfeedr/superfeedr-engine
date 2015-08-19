require 'openssl'

class RequestValidator
  attr_reader :error, :feed

  def initialize(request, params)
    @signature = request.headers['HTTP_X_HUB_SIGNATURE']
    @feed_id = params[:feed_id]
  end

  def valid?
    if @signature.blank?
      @error = "Missing signature. Ignored payload for #{@feed_id}. Use retrieve if missing."
      return false
    end

    @algo, @hash = @signature.split('=')
    if @algo != "sha1"
      @error = "Unknown signature mechanism #{algo}. Ignored paylod for #{@feed_id}. Use retrieve if missing.")
      return false
    end

    @feed = feed_klass.find(@feed_id)

    if @feed.blank?
      @error = "Unknown notification for #{@feed_id}"
      return false
    end

    digest = OpenSSL::Digest.new(@algo)
    computed = OpenSSL::HMAC.hexdigest(digest, @feed.secret, @request.raw_post)
    if computed != @hash
      @error = "Non matching signature. Ignored paylod for #{@feed_id}. Use retrieve if missing."
      return false
    end

    if !feed_klass.method_defined?(:notified)
      @error = "Please make sure your #{@feed_id} intances have a 'notified' method."
      return false
    end

    return true
  end

  protected

  def feed_klass
    SuperfeedrEngine::Engine.feed_class.constantize
  end
end
