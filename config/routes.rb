Webring::Engine.routes.draw do
  resources :members do
    member do
      patch :approve
      patch :reject
    end
  end

  get 'next', to: 'navigation#next'
  get 'previous', to: 'navigation#previous'
  get 'random', to: 'navigation#random'

  root to: 'navigation#random'
end
