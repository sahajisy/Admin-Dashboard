Rails.application.routes.draw do
  get 'exam_sessions/new'
  get 'exam_sessions/create'
  get 'exam_sessions/destroy'
  get 'exams/index'
  get 'exams/create'
  get 'exams/save'
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

  resources :exam_sessions, only: [:new, :create, :destroy]
  
  resources :exams, only: [:show] do
    member do
      get :details  # To view exam details
      post :submit  # To submit the exam
      #get :result  # To view exam result
    end
    collection do
      get :thank_you  # Thank you page after exam submission
    end
    collection do
      get :wrong_exam # For wrong examinees
    end
  end

end
