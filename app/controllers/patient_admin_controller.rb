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
    puts 'getting config'
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
            fitness_data = response.records.first
            event_data[:intensity] = fitness_data.intensity
            event_data[:distance] = fitness_data.distance
            event_data[:duration] = fitness_data.duration
            event_data[:calories] = fitness_data.calories
            event_data[:activityCategory] = fitness_data.activity_category
          when "routine"
            response = @@client.get_routine(options)
            # For now, we're just getting the first result from the response
            routine_data = response.records.first
            event_data[:steps] = routine_data.steps
            event_data[:distance] = routine_data.distance
            event_data[:floors] = routine_data.floors
            event_data[:elevation] = routine_data.elevation
            event_data[:caloriesBurned] = routine_data.calories_burned
            event_data[:water] = routine_data.water
          when "nutrition"
            response = @@client.get_nutritions(options)
            # For now, we're just getting the first result from the response
            nutrition_data = response.records.first
            event_data[:calories] = nutrition_data.calories
            event_data[:carbohydrates] = nutrition_data.carbohydrates
            event_data[:fat] = nutrition_data.fat
            event_data[:fiber] = nutrition_data.fiber
            event_data[:protein] = nutrition_data.protein
            event_data[:sodium] = nutrition_data.sodium
            event_data[:water] = nutrition_data.water
            event_data[:meal] = nutrition_data.meal
          when "weight"
            response = @@client.get_weight(options)
            # For now, we're just getting the first result from the response
            weight_data = response.records.first
            event_data[:weight] = weight_data.weight
            event_data[:height] = weight_data.height
            event_data[:freeMass] = weight_data.free_mass
            event_data[:fatPercent] = weight_data.fat_percent
            event_data[:massWeight] = weight_data.mass_weight
            event_data[:bmi] = weight_data.bmi
          when "diabetes"
            puts 'trying to get data from diabetes'
            response = @@client.get_diabetes(options)
            # For now, we're just getting the first result from the response
            diabetes_data = response.records.first
            puts diabetes_data
            event_data[:cPeptide] = diabetes_data.c_peptide
            event_data[:fastingPlasmaGlucoseTest] = diabetes_data.fasting_plasma_glucose_test
            event_data[:hba1c] = diabetes_data.hba1c
            event_data[:insulin] = diabetes_data.insulin
            event_data[:oralGlucoseToleranceTest] = diabetes_data.oral_glucose_tolerance_test
            event_data[:randomPlasmaGlucoseTest] = diabetes_data.random_plasma_glucose_test
            event_data[:triglyceride] = diabetes_data.triglyceride
            event_data[:bloodGlucose] = diabetes_data.blood_glucose
          when "biometrics"
            response = @@client.get_biometrics(options)
            # For now, we're just getting the first result from the response
            biometrics_data = response.records.first
            event_data[:bloodCalcium] = biometrics_data.blood_calcium
            event_data[:bloodChromium] = biometrics_data.blood_chromium
            event_data[:bloodFolicAcid] = biometrics_data.blood_folic_acid
            event_data[:bloodMagnesium] = biometrics_data.blood_magnesium
            event_data[:bloodPotassium] = biometrics_data.blood_potassium
            event_data[:bloodSodium] = biometrics_data.blood_sodium
            event_data[:bloodVitaminB12] = biometrics_data.blood_vitamin_b12
            event_data[:bloodZinc] = biometrics_data.blood_zinc
            event_data[:creatine_kinase] = biometrics_data.creatine_kinase
            event_data[:crp] = biometrics_data.crp
            event_data[:diastolic] = biometrics_data.diastolic
            event_data[:ferritin] = biometrics_data.ferritin
            event_data[:hdl] = biometrics_data.hdl
            event_data[:hscrp] = biometrics_data.hscrp
            event_data[:il6] = biometrics_data.il6
            event_data[:ldl] = biometrics_data.ldl
            event_data[:restingHeartrate] = biometrics_data.resting_heartrate
            event_data[:systolic] = biometrics_data.systolic
            event_data[:testosterone] = biometrics_data.testosterone
            event_data[:totalCholesterol] = biometrics_data.total_cholesterol
            event_data[:tsh] = biometrics_data.tsh
            event_data[:uricAcid] = biometrics_data.uric_acid
            event_data[:vitaminD] = biometrics_data.vitamin_d
            event_data[:whiteCellCount] = biometrics_data.white_cell_count
            event_data[:spo2] = biometrics_data.spo2
            event_data[:temperature] = biometrics_data.temperature
          when "sleep"
            response = @@client.get_sleep(options)
            # For now, we're just getting the first result from the response
            sleep_data = response.records.first
            event_data[:awake] = sleep_data.awake
            event_data[:deep] = sleep_data.deep
            event_data[:light] = sleep_data.light
            event_data[:rem] = sleep_data.rem
            event_data[:timesWoken] = sleep_data.times_woken
            event_data[:totalSleep] = sleep_data.total_sleep
          when "tobacco_cessations"
            response = @@client.get_tobacco_cessations(options)
          else
            response = nil
        end

        puts "trying to get registration"
        # Make web requests to Bjond on a separate thread
        BjondRegistration.all.each do |r|
          puts "in registration"
          ap r
          vldc = ValidicConfiguration.find_by_bjond_registration_id(r.id)
          puts vldc
          event_data[:bjondPatientId] = vldc.sample_person_id
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
