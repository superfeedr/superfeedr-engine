# SuperfeedrEngine

This Rails engine let's you integrate [Superfeedr](https://superfeedr.com) smoothly into any Rails 4+ application (not tested with Rails 3.X). It lets you consume RSS feeds in your Rails application using Superfeedr's [PubSubHubbub](http://documentation.superfeedr.com/subscribers.html#webhooks) API.

*Warning*: At this point, this engine is only to be used with [XML feeds subscriptions](http://documentation.superfeedr.com/subscribers.html#xml-based-feeds).

The engine relies on the [Rack Superfeedr](https://rubygems.org/gems/rack-superfeedr) library for subscriptions, unsubscriptions, retrieval and listing of subscriptions. It creates a route used for webhooks and yields notifications.

Gory details such as building webhook URLs, using secrets and handling signatures verifications are performed by default by this engine.

## How-To

### Install

In your Gemfile, add `gem 'superfeedr_engine'` and run `bundle update`.

### Configure

Add a configuration file: `config/initailizers/superfeedr_engine.rb` with the following:

```ruby
SuperfeedrEngine::Engine.feed_class = "Feed" # Use the class you use for feeds. (Its name as a string)
# This class needs to have the following attributes/methods:
# * url: should be the main feed url
# * id: a unique id (string) for each feed (can be the primary index in your relational table)
# * secret: a secret which should never change and be unique for each feed. It must be hard to guess. (a md5 or sha1 string works fine!)

SuperfeedrEngine::Engine.base_path = "/superfeedr_engine/" # Base path for the engine don't forget the trailing /

SuperfeedrEngine::Engine.host = "5ea1e5ed83bf5555.a.passageway.io" # Your hostname (no http). Used for webhooks!
# When debugging, you can use tools like https://www.runscope.com/docs/passageway to
# share your local web server with superfeedr's API via a public URL

SuperfeedrEngine::Engine.login = "demo" # Superfeedr username

SuperfeedrEngine::Engine.password = "8ac38a53cc32f71a6445e880f76fc865" # Token value
# make sure it has the associated rights you need (subscribe,unsubscribe,retrieve,list)

SuperfeedrEngine::Engine.scheme = "http" # Can use HTTPS or a different port with SuperfeedrEngine::Engine.port
```

### Mount

Update routes in `config/routes.rb` to mount the Engine.

```ruby
mount SuperfeedrEngine::Engine => SuperfeedrEngine::Engine.base_path # Use the same to set path in the engine initialization!
```

### Profit! (not really, you should start actually using the engine!)

You can call perform the following calls:

```ruby
body, ok = SuperfeedrEngine::Engine.subscribe(feed, {:retrieve => true}) # Will subscribe your application to the feed object and will retrieve its past content yielded as a JSON string in body.

body, ok = SuperfeedrEngine::Engine.retrieve(feed) # Will retrieve the past content of a feed (but you must be subscribed to it first)

body, ok = SuperfeedrEngine::Engine.unsubscribe(feed) # Will stop receiving notifications when a feed changes.
```

Finally, make sure your `SuperfeedrEngine::Engine.feed_class` has a `notified` method which will be called by the engine when new content is received by your application. You'll probably want to save the content of this notification.

The method can have 1, 2 or 3 arguments. The first argument will be a Ruby hash with the content of the notification. The 2nd (optional) argument is the raw text notification. The 3rd one (optional as well) will be the headers for the notifcation's HTTP request.

By default, this engine will subscribe to Superfeedr using the `JSON` format. Please check our [JSON schema](http://documentation.superfeedr.com/schema.html#json) for more details.


Please check our example Rails application, deployed on  and whose code can be found in `example`


### Development note:

When develiping your application you probably use localhost... which means that your Rails application is not reachable by our servers and we won't be able to send you notifications.

To handle this, feel free to use any of these tools which expose your Rails application (on port 3000) to the web using temporary URLs:

- [passageway](https://www.runscope.com/docs/passageway)
- [forwardhq](https://forwardhq.com/)
- [ngrok](https://ngrok.com/)





