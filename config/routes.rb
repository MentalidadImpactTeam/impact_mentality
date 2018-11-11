Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',sessions: 'users/sessions', confirmations: 'users/confirmations', passwords: 'users/passwords' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    post 'checkuser' => 'users/registrations#checkuser'
    get 'active_confirmation' => 'users/confirmations#active_confirmation'
  end
  
  root to: 'dashboard#index'
  post 'rutinas' => "home#rutinas"
  resources :routines do 
    collection do 
      post "list_exercises" => 'routines#list_exercises'
      post "change_exercise" => 'routines#change_exercise'
      post "mark_exercise_done" => 'routines#mark_exercise_done'
    end
  end

  resources :webhook, only: [:index] do
    collection do
      post "conekta" => "webhook#procesar"
    end
  end
  resources :accounts do
    collection do 
      post "add_card" => 'accounts#add_card'
      post "delete_card" => 'accounts#delete_card'
      post "card_default" => 'accounts#card_default'
    end
  end
  resources :profiles
  resources :administrator
end
