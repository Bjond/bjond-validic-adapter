Rails.application.routes.draw do
  
  root 'bjond_registrations#index'

  get  '/validic/patient_admin/create_user' => 'patient_admin#verify_create_user'
  post '/validic/patient_admin/create_user' => 'patient_admin#create_user'

  get  '/validic/patient_admin/get_users' => 'patient_admin#verify_get_users'
  post '/validic/patient_admin/get_users' => 'patient_admin#get_users'

  get  '/validic/patient_admin/get_synced_apps' => 'patient_admin#get_synced_apps'
  post '/validic/patient_admin/get_synced_apps' => 'patient_admin#get_synced_apps'

  get  '/validic/patient_admin/push_service_endpoint' => 'patient_admin#verify_push_service_endpoint'
  post '/validic/patient_admin/push_service_endpoint' => 'patient_admin#push_service_endpoint'

  resources :validic_configurations, :bjond_validic_user_conversions
end
