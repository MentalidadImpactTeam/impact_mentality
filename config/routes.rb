Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations',sessions: 'users/sessions', confirmations: 'users/confirmations', passwords: 'users/passwords' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    post 'checkuser' => 'users/registrations#checkuser'
    post 'create_conekta_subscription' => 'users/registrations#create_conekta_subscription'
    get 'active_confirmation' => 'users/confirmations#active_confirmation'
    get 'active_trainer_confirmation' => 'users/confirmations#active_trainer_confirmation'
  end
  
  root to: 'landing#index'
  get "equipos" => "landing#equipos"
  get "nosotros" => "landing#nosotros"
  get "contacto" => "landing#contacto"

  get "player_list" => "dashboard#player_list"
  get "dashboard" => 'dashboard#index'
  get "dashboard/:id" => 'dashboard#index'
  post "add_trainer_user" => "dashboard#add_trainer_user"
  post "delete_trainer_user" => "dashboard#delete_trainer_user"
  post "exercise_graph" => "dashboard#exercise_graph"
  get "mailer" => "dashboard#mailer_test"

  post 'rutinas' => "home#rutinas"
  resources :routines do 
    collection do 
      get "download_pdf" => 'routines#download_pdf'
      post "list_exercises" => 'routines#list_exercises'
      post "change_exercise" => 'routines#change_exercise'
      post "mark_exercise_done" => 'routines#mark_exercise_done'
      post "test_result" => 'routines#test_result'
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
      post "cancel_subscription" => 'accounts#cancel_subscription'
    end
  end
  resources :profiles do 
    collection do 
      post 'profile_image' => "profiles#update_profile_image"
      post 'add_trainer' => "profiles#add_trainer"
    end
  end
  namespace :administrator do
    get "users" => "admin#list_users"
    get "users/page" => "admin#page_users"
    post "users/search" => "admin#search_users"
    get "users/new" => "admin#new_user"
    post "users/delete" => "admin#delete_user"
    post "users/change_type" => "admin#change_user_type"
    get "exercises" => "admin#list_exercises"
    get "exercises/change_list_exercises" => "admin#change_list_exercises"
    post "exercises/edit_exercise" => "admin#add_edit_exercise"
    post "exercises/delete_exercise" => "admin#delete_exercise"
    post "exercises/search" => "admin#search_exercises"
    get "users/:id" => "admin#show_user"
  end
end
