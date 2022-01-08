Rails.application.routes.draw do
  get 'searches/top'
  get 'searches/result'
  get 'working_tasks/index'
  get 'working_tasks/new'
  get 'working_tasks/edit'
  get 'tasks/index'
  get 'tasks/new'
  get 'tasks/edit'
  get 'users/show'
  get 'users/edit'
  get 'homes/top'
  get 'homes/about'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
