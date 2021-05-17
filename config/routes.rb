Rails.application.routes.draw do

  # Deviseのログイン画面をrootに設定、そのままだと設定できないので、devise＿scopeを使用
  devise_scope :user do
    root to: 'users/sessions#new'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :users do
    resources :tasks
    get '/tasks_all_incomplete', to: 'tasks#tasks_all_incomplete'
    get '/tasks_all_history', to: 'tasks#tasks_all_history'
    resources :tasks_request
    get '/tasks_request_all_history', to: 'tasks_request#tasks_request_all_history'
    get '/tasks_request_reply', to: 'tasks_request#tasks_request_reply'
    patch '/update_tasks_request_reply', to: 'tasks_request#update_tasks_request_reply'
    get '/tasks_request_reply_confirm', to: 'tasks_request#tasks_request_reply_confirm'
  end

  resources :events
end
