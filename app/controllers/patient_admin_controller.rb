class PatientAdminController < ApplicationController

  # skip_before_filter :verify_authenticity_token, :only => [:arrival, :discharge, :transfer, :registration, :cancel, :pre_admit, :visit_update]

  require 'bjond-api'
  require 'validic'
  
  client = Validic::Client.new

  def create_user(bjondId)
    response = client.provision_user(uid: bjondId)
    puts 
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
    response = client.get_users(user_id: bjondId)
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
    client.get_user_synced_apps(authentication_token: 'L9RFSRnJvkwfiZm8vEc4')
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
    puts request.raw_post
    parsed = JSON.parse(request.raw_post)
    data = parsed["data"]
    if (!data.nil?)
      data.all.each do |activity|
        user_id = activity["_id"]
        activity_type = activity["activity_type"]
        options = {
          :user_id => user_id,
        }
        event_data = {
          :bjondPatientId => user_id,
        }
        case activity_type
          when "fitness"
            response = client.get_fitness(options)
          when "routine"
            response = client.get_routine(options)
          when "nutritions"
            response = client.get_nutritions(options)
          when "weight"
            response = client.get_weight(options)
          when "diabetes"
            event_id = '3288feb8-7c20-490e-98a1-a86c9c17da87'
            response = client.get_diabetes(options)
            puts response
            # For now, we're just getting the first result from the response
            diabetes_data = response["diabetes"][0]
            event_data[:cPeptide] = diabetes_data["c_peptide"]
            event_data[:fastingPlasmaGlucoseTest] = diabetes_data["fasting_plasma_glucose_test"]
            event_data[:hba1c] = diabetes_data["hba1c"]
            event_data[:insulin] = diabetes_data['insulin']
            event_data[:oralGlucoseToleranceTest] = diabetes_data['oral_glucose_tolerance_test']
            event_data[:randomPlasmaGlucoseTest] = diabetes_data['random_plasma_glucose_test']
            event_data[:triglyceride] = diabetes_data['triglyceride']
            event_data[:bloodGlucose] = diabetes_data['blood_glucose']
          when "biometrics"
            response = client.get_biometrics(options)
          when "sleep"
            response = client.get_sleep(options)
          when "tobacco_cessations"
            response = client.get_tobacco_cessations(options)
          else
            response = nil
            event_id = nil
        end

        puts event_data

        # Make web requests to Bjond on a separate thread
        BjondRegistration.all.each do |r|
          ap r
          rdxc = ValidicConfiguration.find_by_bjond_registration_id(r.id)
          puts event_data.to_json
          puts "firing now!"
          Thread.new do 
            begin
              BjondApi::fire_event(r, event_data.to_json, event_id)
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

  end

end
