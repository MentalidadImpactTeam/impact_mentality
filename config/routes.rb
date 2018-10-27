Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',sessions: 'users/sessions' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    post 'checkuser' => 'users/registrations#checkuser'
  end

  root to: 'dashboard#index'
  post 'rutinas' => "home#rutinas"
  resources :routines do 
    collection do 
      post "list_exercises" => 'routines#list_exercises'
      post "change_exercise" => 'routines#change_exercise'
    end
  end

  resources :webhook, only: [:index] do
    collection do
      post "conekta" => "webhook#procesar"
    end
  end
  resources :accounts
end
