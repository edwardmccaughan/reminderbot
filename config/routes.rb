Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'task_manager' => 'task_manager#index'
  get 'task_manager_scheduler' => 'task_manager#scheduler'

  get 'delete_tasks' => 'debug#delete_tasks'
  get 'delete_messages' => 'debug#delete_messages'
  get 'new_thread' => 'debug#new_thread'


  # Defines the root path route ("/")
  # root "posts#index"

  resources :messages
end
