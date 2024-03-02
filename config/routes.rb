Rails.application.routes.draw do
  resources :categories do
    resources :tasks
  end
  devise_for :users 
  root 'home#index'
end
