Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',sessions: 'users/sessions', confirmations: 'users/confirmations', passwords: 'users/passwords' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    post 'checkuser' => 'users/registrations#checkuser'
    get 'active_confirmation' => 'users/confirmations#active_confirmation'
    get 'active_trainer_confirmation' => 'users/confirmations#active_trainer_confirmation'
  end
  
  root to: 'dashboard#index'

  get "player_list" => "dashboard#player_list"
  get "dashboard/:id" => 'dashboard#index'
  post "add_trainer_user" => "dashboard#add_trainer_user"
  post "delete_trainer_user" => "dashboard#delete_trainer_user"

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
  resources :profiles do 
    collection do 
      post 'profile_image' => "profiles#update_profile_image"
    end
  end
  namespace :administrator do
    get "users" => "admin#list_users"
    post "users/search" => "admin#search_users"
    get "exercises" => "admin#list_exercises"
    get "exercises/change_list_exercises" => "admin#change_list_exercises"
    post "exercises/edit_exercise" => "admin#edit_exercise"
    post "exercises/search" => "admin#search_exercises"
    get "users/:id" => "admin#show_user"
  end
end
