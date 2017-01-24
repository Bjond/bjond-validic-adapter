Rails.application.routes.draw do
  
  root 'bjond_registrations#index'

  get  '/validic/patient_admin/arrival' => 'patient_admin#verify_arrival'
  post '/validic/patient_admin/arrival' => 'patient_admin#arrival'

  get  '/validic/patient_admin/discharge' => 'patient_admin#verify_discharge'
  post '/validic/patient_admin/discharge' => 'patient_admin#discharge'

  get  '/validic/patient_admin/transfer' => 'patient_admin#verify_transfer'
  post '/validic/patient_admin/transfer' => 'patient_admin#transfer'

  get  '/validic/patient_admin/registration' => 'patient_admin#verify_registration'
  post '/validic/patient_admin/registration' => 'patient_admin#registration'

  get  '/validic/patient_admin/cancel' => 'patient_admin#verify_cancel'
  post '/validic/patient_admin/cancel' => 'patient_admin#cancel'

  get  '/validic/patient_admin/pre_admit' => 'patient_admin#verify_pre_admit'
  post '/validic/patient_admin/pre_admit' => 'patient_admin#pre_admit'

  get  '/validic/patient_admin/visit_update' => 'patient_admin#visit_update'
  post '/validic/patient_admin/visit_update' => 'patient_admin#visit_update'

  resources :validic_configurations, :bjond_validic_user_conversion
end
