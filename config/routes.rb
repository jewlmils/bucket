Rails.application.routes.draw do

  resources :categories do
    resources :tasks, except: [:index]
  end

  devise_for :users 
  root 'categories#index'

  get '*path', to: redirect('/', status: 302)
  
end