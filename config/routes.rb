Rails.application.routes.draw do
  get 'exams/index'
  get 'exams/login'
  get 'exams/show'
  get 'exams/submit'
  mount ActionCable.server => '/cable'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root to: 'admin/dashboard#index'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

#for letter_opener routing
  mount LetterOpenerWeb::Engine, at: "/letter_opener"

  # Defines the root path route ("/")
  # root "posts#index"


  resources :exams, only: [:index, :show] do
    post :submit, on: :member
  end
end
