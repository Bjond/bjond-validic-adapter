class PatientAdminController < ApplicationController

  skip_before_filter :verify_authenticity_token, :only => [:push_service_endpoint]

  require 'bjond-api'
  require 'validic'

  @@client = Validic::Client.new

  def create_user(bjondId)
    response = @@client.provision_user(uid: bjondId)
  end

  def verify_create_user
    if request.headers['verification-token'] == ENV['VALIDIC_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

  def get_users(bjondId)
    response = @@client.get_users(user_id: bjondId)
  end

  def verify_get_users
    if request.headers['verification-token'] == ENV['VALIDIC_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

  def get_synced_apps(patient='')
    @@client.get_user_synced_apps(authentication_token: 'L9RFSRnJvkwfiZm8vEc4')
  end

  def get_synced_apps
    if request.headers['verification-token'] == ENV['VALIDIC_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

  def push_service_endpoint
    config = BjondApi::BjondAppConfig.instance
    # Handles payload from Redox, relays to Bjond Server Core in form of event.
    parsed = JSON.parse(request.raw_post)
    data = parsed["data"]
    puts data
    if (!data.nil?)
      data.each do |activity|
        bjond_id = BjondValidicUserConversion.find_by(validic_id: activity["_id"])
        activity_type = activity["activity_type"]
        options = {
          # Hard code to their test person for now
          user_id: '5670645b96014ca88c000059',
          start_date: '2015-01-01T00:00:00+00:00'
        }
        event_data = {}
        case activity_type
          when "fitness"
            response = @@client.get_fitness(options)
            # For now, we're just getting the first result from the response
            fitness_data = response.records.first.to_json
            fitness_fields = ['intensity', 'distance', 'duration', 'calories', 'activity_category']
            fitness_fields.each do |snake_key|
               event_data[snake_key.camelize(:lower)] = diabetes_data[snake_key]
            end
          when "routine"
            response = @@client.get_routine(options)
            # For now, we're just getting the first result from the response
            routine_data = response.records.first.to_json
            routine_fields = ['steps', 'distance', 'floors', 'elevation', 'calories_burned', 
              'water']
            routine_fields.each do |snake_key|
               event_data[snake_key.camelize(:lower)] = diabetes_data[snake_key]
            end
          when "nutrition"
            response = @@client.get_nutritions(options)
            # For now, we're just getting the first result from the response
            nutrition_data = response.records.first.to_json
            nutrition_fields = ['calories', 'carbohydrates', 'fat', 'fiber', 'protein', 'sodium', 
              'water', 'meal']
            nutrition_fields.each do |snake_key|
               event_data[snake_key.camelize(:lower)] = diabetes_data[snake_key]
            end
          when "weight"
            response = @@client.get_weight(options)
            # For now, we're just getting the first result from the response
            weight_data = response.records.first.to_json
            weight_fields = ['weight', 'height', 'free_mass', 'fat_percent', 'mass_weight', 'bmi']
            weight_fields.each do |snake_key|
               event_data[snake_key.camelize(:lower)] = diabetes_data[snake_key]
            end
          when "diabetes"
            response = @@client.get_diabetes(options)
            # For now, we're just getting the first result from the response
            diabetes_data = response.records.first.to_json
            diabetes_fields = ['c_peptide', 'fasting_plasma_glucose_test', 'hba1c', 'insulin', 
              'oral_glucose_tolerance_test', 'random_plasma_glucose_test', 'triglyceride', 
              'blood_glucose']
            diabetes_fields.each do |snake_key|
               event_data[snake_key.camelize(:lower)] = diabetes_data[snake_key]
            end
          when "biometrics"
            response = @@client.get_biometrics(options)
            # For now, we're just getting the first result from the response
            biometrics_data = response.records.first.to_json
            biometrics_fields = ['blood_calcium', 'blood_chromium', 'blood_folic_acid', 
              'blood_magnesium', 'blood_potassium', 'blood_sodium', 'blood_vitamin_b12', 
              'blood_zinc', 'creatine_kinase', 'crp', 'diastolic', 'ferritin', 'hdl', 'hscrp', 
              'il6', 'ldl','resting_heartrate', 'systolic', 'testosterone', 'total_cholesterol', 
              'tsh', 'uric_acid','vitamin_d', 'white_cell_count', 'spo2', 'temperature']
            biometrics_fields.each do |snake_key|
               event_data[snake_key.camelize(:lower)] = diabetes_data[snake_key]
            end
          when "sleep"
            response = @@client.get_sleep(options)
            # For now, we're just getting the first result from the response
            sleep_data = response.records.first.to_json
            sleep_fields = ['awake', 'deep', 'light', 'rem', 'times_woken', 'total_sleep']
            sleep_fields.each do |snake_key|
               event_data[snake_key.camelize(:lower)] = diabetes_data[snake_key]
            end
          when "tobacco_cessations"
            response = @@client.get_tobacco_cessations(options)
          else
            response = nil
        end

        # Make web requests to Bjond on a separate thread
        BjondRegistration.all.each do |r|
          ap r
          vldc = ValidicConfiguration.find_by_bjond_registration_id(r.id)
          event_data[:bjondPersonId] = vldc.sample_person_id
          puts event_data.to_json
          puts "firing now!"
          Thread.new do 
            begin
              integration_event = config.active_definition.integrationEvent.find { |x| x.jsonKey == activity_type + 'Event'}
              BjondApi::fire_event(r, event_data.to_json, integration_event.id)
            rescue StandardError => bang
              puts "Encountered an error when firing event associated with BjondRegistration with id: "
              puts r.id
              puts bang
            end
          end
        end
        render :json => {
          :status => 'OK'
        }
      end
    end

  end

  def verify_push_service_endpoint
    if request.headers['verification-token'] == ENV['VALIDIC_VERIFICATION_TOKEN']
      render :text => params[:challenge]
    else
      render :json => {
        :data => "Failed to verify token."
      }
    end
  end

end
