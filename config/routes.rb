RailsPresense::Engine.routes.draw do
  resources :presence, only: [:show, :index] do
    collection do
      post :update
    end
  end
end
