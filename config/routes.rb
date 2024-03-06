Rails.application.routes.draw do
  resources :categories do
    resources :tasks
  end
  devise_for :users 
  root 'home#index'

  get '*path', to: redirect('/categories', status: 302)
end
