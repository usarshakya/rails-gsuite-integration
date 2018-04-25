Rails.application.routes.draw do
  get 'gsuite_sync_users', to: 'users#gsuite_sync_users'
end
