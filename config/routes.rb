Rails.application.routes.draw do
  root to: "homes#top"
  get "/about", to: "homes#about"
  devise_for :users
  resources :users, only: [:show, :edit, :update] do
    # ----------task------------------------------------
    resources :tasks, except: [:show]
    delete "tasks/:id/destroy_icon", to: "tasks#destroy_icon", as: "task_destroy_icon"
    # ----------working_task------------------------------------
    resources :working_tasks, except: [:index,:show, :create]
    post "working_tasks/new/set/:task_id/start", to: "working_tasks#start", as:"working_task_start"
    post "working_tasks/new/set/:task_id/stop", to: "working_tasks#stop", as:"working_task_stop"
    # タスクを選んでセットするために必要
    get "working_tasks/new/set/:task_id", to: "working_tasks#set", as:"set_new_working_task"
    # indexのみ、:date（日付の情報）をURLから送るため、別に書いている
    get "working_tasks/:date", to: "working_tasks#index",as: "working_tasks"
    # ----------search------------------------------------
    # 検索機能用
    get "working_tasks/search", to: "searches#top", as: "search"
    get "working_tasks/search/result", to: "searches#result", as: "search_result"
    # ----------events------------------------------------
    # カレンダータグ付け
    resources :events, only: [:new, :create, :destroy]
  end
  delete "users/:id/destroy_icon", to: "users#destroy_image", as: "user_destroy_image"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
