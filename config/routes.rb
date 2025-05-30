Webring::Engine.routes.draw do
  resources :members

  get 'next', to: 'navigation#next'
  get 'previous', to: 'navigation#previous'
  get 'random', to: 'navigation#random'

  # Widget routes
  get 'widget.js', to: 'widget#show', format: 'js', as: :widget

  root to: 'navigation#random'
end
