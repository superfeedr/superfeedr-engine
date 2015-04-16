SuperfeedrEngine::Engine.routes.draw do
	root :to => 'pubsubhubbub#index'

	post '/:feed_id', :to => 'pubsubhubbub#notify', :as => :notify

end
