Rails.application.routes.draw do
  get 'pages/about'
  get 'pages/blog'
  get 'pages/chat'
  get 'pages/content'
  get 'pages/frapp_talk'
  get 'pages/fusion'
  get 'pages/profile'
  get 'maps/google_maps'
  get 'events/past'
  get 'events/upcoming'
  get '/sign_out' => 'users/sessions#destroy'
  namespace :admin do
      resources :users

      root to: "users#index"
    end
  get 'products/:id', to: 'products#show', :as => :products
  devise_for :users, :controllers => { :registrations => 'registrations' }
  devise_scope :user do
    post 'pay', to: 'registrations#pay'
  end
  resources :users
  root :to => 'visitors#index'
end
