RailsPresence::Engine.routes.draw do
  get 'health/', to: 'health#show', as: :health_check
  resources :presence, only: [:show, :index] do
    collection do
      post :update
    end
  end
end
