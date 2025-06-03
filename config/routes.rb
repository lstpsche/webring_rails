Webring::Engine.routes.draw do
  get 'next', to: 'navigation#next'
  get 'previous', to: 'navigation#previous'
  get 'random', to: 'navigation#random'
  get 'widget.js', to: 'widget#show', format: 'js', as: :widget

  root to: 'navigation#random'
end
