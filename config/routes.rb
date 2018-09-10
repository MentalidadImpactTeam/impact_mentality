Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    post 'checkuser' => 'users/registrations#checkuser'
  end

  root to: 'home#index'
  post 'rutinas' => "home#rutinas"
  resources :routines
end
