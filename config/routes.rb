Rails.application.routes.draw do
  
  root 'static_pages#top'
  get '/signup', to: 'users#new'
  
   # ログイン機能
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  
  resources :users do
    collection { post :import }
    member do
      get 'basic_infomation_edit'
      get 'attendances/edit_one_month'
      patch'attendances/update_one_month'
      get 'attendances/working_users'
      get 'edit_overtime_notice'
      patch 'update_overtime_notice'
      get 'edit_attendance_apply'
      patch 'update_attendance_apply'
      patch 'attendances/update_zokucho_approval'
      get 'edit_zokucho'
      patch 'update_zokucho'
      get 'log_edit'
      get 'edit_basic_info'
      patch 'update_basic_info'
    end
    resources :attendances, only: [:update]
    resources :bases
    
    get 'attendances/:id/edit_overtime', to: 'attendances#edit_overtime', as: :edit_overtime
    patch 'attendances/:id/update_overtime', to: 'attendances#update_overtime', as: :update_overtime
    
  end
  
  get 'users/:id/show', to: 'users#show_view_only', as: :show_view_only
end
