$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "superfeedr_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "superfeedr_engine"
  s.version     = SuperfeedrEngine::VERSION
  s.authors     = ["superfeedr"]
  s.email       = ["julien@superfeedr.com"]
  s.homepage    = "https://superfeedr.com"
  s.summary     = "A Rails engine to consume RSS in a Rails application via Superfeedr."
  s.description = "SuperfeedrEngine is a Rails engine to consume RSS in a Rails application via Superfeedr. It handles routing, subscriptions, unsubscriptions, retrieval and notifications."
  s.license     = "MIT"
  s.metadata    = {

  }
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "rack-superfeedr", "~> 0.4.4"

  s.required_ruby_version = '>= 1.9.3'
end
