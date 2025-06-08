Webring::Engine.routes.draw do
  get 'next', to: 'navigation#next'
  get 'previous', to: 'navigation#previous'
  get 'random', to: 'navigation#random'

  root to: 'navigation#random'
end
