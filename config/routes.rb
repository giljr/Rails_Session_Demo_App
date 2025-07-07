Rails.application.routes.draw do
  root 'sessions#show'

  get    '/login',  to: 'sessions#new'      # 👈 this shows the form
  post   '/login',  to: 'sessions#create'
  get    '/profile', to: 'sessions#show'
  delete '/logout', to: 'sessions#destroy'
end
