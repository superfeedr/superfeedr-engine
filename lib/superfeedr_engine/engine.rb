require 'rack-superfeedr'
require 'uri'

def valid?(url)
  uri = URI.parse(url)
  uri.kind_of?(URI::HTTP)
rescue URI::InvalidURIError
  false
end

module SuperfeedrEngine

  class Engine < ::Rails::Engine
    isolate_namespace SuperfeedrEngine
    mattr_accessor :feed_class

    extend SuperfeedrAPI
  
    def self.subscribe(object, opts = {})
    	raise "Missing url method or property on #{object}" unless object.class.method_defined? :url #=> true
    	raise "Missing id method or property on #{object}" unless object.class.method_defined? :id #=> true
    	raise "Missing secret method or property #{object}" unless object.class.method_defined? :id #=> true

    	raise "#{object}#url needs to be a URL" unless valid?(object.url) 
    	raise "#{object}#id needs to not empty" if object.id.to_s.empty?
    	raise "#{object}#secret needs to not empty" if object.secret.to_s.empty?

    	opts.merge!({
    		secret: object.secret,
    		format: 'json' # Force the use of the JSON
    	})

    	super(object.url, object.id, opts)
    end

  end
end
