Rails.application.routes.draw do

  resources :feeds do
    member do
      get 'retrieve'
      post 'subscribe'
    end
  end

  resources :entries

  mount SuperfeedrEngine::Engine => SuperfeedrEngine::Engine.base_path # Use the same to set path in the engine initialization!
end
