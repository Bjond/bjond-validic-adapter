require 'bjond-api'



config = BjondApi::BjondAppConfig.instance

config.group_configuration_schema = {
  :id => 'urn:jsonschema:com:bjond:persistence:bjondservice:GroupConfiguration',
  :title => 'bjond-validic-app-schema',
  :type  => 'object',
  :properties => {
    :api_key => {
      :type => 'string',
      :description => 'Validic API Key',
      :title => 'Validic API Key'
    },
    :secret => {
      :type => 'string',
      :description => 'Validic Source Secret',
      :title => 'Validic Source Secret'
    },
    :sample_person_id => {
      :type => 'string',
      :description => 'Bjönd Person ID. This can be any person ID in the tenant.',
      :title => 'Bjönd Patient ID'
    }
  },
  :required => ['sample_field']
}.to_json

config.encryption_key_name = 'VALIDIC_ENCRYPTION_KEY'

def config.configure_group(result, bjond_registration)
  validic_config = ValidicConfiguration.find_or_initialize_by(:bjond_registration_id => bjond_registration.id)
  # We don't require a api key or secret currently
  # if (validic_config.api_key != result['api_key'] || validic_config.secret != result['secret'] || redox_config.sample_person_id != result['sample_person_id'])
  if (result['sample_person_id'] != nil)
    # validic_config.api_key = result['api_key'] 
    # validic_config.secret = result['secret']
    validic_config.sample_person_id = result['sample_person_id']
    validic_config.save
  end
  return validic_config
end

def config.get_group_configuration(bjond_registration)
  validic_config = ValidicConfiguration.find_by_bjond_registration_id(bjond_registration.id)
  if (validic_config.nil?)
    puts 'No configuration has been saved yet.'
    return {:secret => '', :sample_person_id => '', :api_key => ''}
  else
    return validic_config
  end
end

### The integration app definition is sent to Bjond-Server core during registration.
config.active_definition = BjondApi::BjondAppDefinition.new.tap do |app_def|
  app_def.id           = '58d1e6fd-19ea-4bd7-b31b-3852539588f0'
  app_def.author       = 'Bjönd, Inc.'
  app_def.name         = 'Bjönd Validic App'
  app_def.description  = 'Testing API functionality'
  app_def.iconURL      = 'https://validic.com/wp-content/themes/Divi-child/images/validic.svg'
  app_def.integrationEvent = [
    BjondApi::BjondEvent.new.tap do |e|
      e.id = '3288feb8-7c20-490e-98a1-a86c9c17da87'
      e.jsonKey = 'diabetesEvent'
      e.name = 'Diabetes Event'
      e.description = 'Validic collates data that Bjond consumes'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = '975e5a5f-fd05-4843-90e9-9bc201a8e48b'
          f.jsonKey = 'bjondPatientId'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '533487d9-baff-4286-a996-00fc034c7b5a'
          f.jsonKey = 'cPeptide'
          f.name = 'C Peptide'
          f.description = 'C peptide levels in ng/mL'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'a11df748-e0d1-4861-8714-8c863692ee70'
          f.jsonKey = 'fastingPlasmaGlucoseTest'
          f.name = 'Fasting Plasma Glucose Test'
          f.description = 'Fasting Plasma Glucose Test levels in mg/dL'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '42f4dd7d-ee5f-4577-b9d8-c206c94f9f5c'
          f.jsonKey = 'hba1c'
          f.name = 'hba1c'
          f.description = 'hba1c Percentage'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '063275d7-4def-4381-8207-8334c708567c'
          f.jsonKey = 'insulin'
          f.name = 'Insulin'
          f.description = 'Insulin levels in U'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '521702c9-69db-4260-8d60-008aa7490692'
          f.jsonKey = 'oralGlucoseToleranceTest'
          f.name = 'Oral Glucose Tolerance Test'
          f.description = 'Oral Glucose Tolerance Test levels in mg/dL'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '2d349abe-859b-4db6-a59a-99339d00caa7'
          f.jsonKey = 'randomPlasmaGlucoseTest'
          f.name = 'Random Plasma Glucose Test'
          f.description = 'Random Plasma Glucose Test levels in mg/dL'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '38fb83e3-d23b-4299-9a7c-a7b9f50feefb'
          f.jsonKey = 'triglyceride'
          f.name = 'Triglyceride'
          f.description = 'Triglyceride levels in mg/dL'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'e720fe2f-cb54-4333-85f2-65f7cc7d1e2b'
          f.jsonKey = 'bloodGlucose'
          f.name = 'Blood Glucose'
          f.description = 'Blood Glucose levels in mg/dL'
          f.fieldType = 'String'
          f.event = e.id
        end
      ]
    end,
    BjondApi::BjondEvent.new.tap do |e|
      e.id = '83cd1b35-7084-4f73-84d9-2991606cf3ca'
      e.jsonKey = 'fitnessEvent'
      e.name = 'Fitness Event'
      e.description = 'Validic collates data that Bjond consumes'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = '19ac2f3b-1b32-4060-b27b-9beb39d3c958'
          f.jsonKey = 'bjondPatientId'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '7db52972-0dfc-485e-97c3-d65879330539'
          f.jsonKey = 'type'
          f.name = 'Activity Type'
          f.description = 'Type of activity as provided by the device'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'c9f3e7c7-005e-4429-9fc5-05081b8c4642'
          f.jsonKey = 'activityCategory'
          f.name = 'Activity Category'
          f.description = 'Type of activity standardized by Validic'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '6e4393e7-00f9-49dc-9cad-b40aed1ab00b'
          f.jsonKey = 'intensity'
          f.name = 'Intensity'
          f.description = 'Subjective intensity'
          f.fieldType = 'String'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'c6b9eb8d-705c-4d2d-beb8-dd25c38493fc'
          f.jsonKey = 'distance'
          f.name = 'Distance'
          f.description = 'Distance in meters'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '1cff1590-5f59-499e-9d61-4e7b83ce3027'
          f.jsonKey = 'duration'
          f.name = 'Duration'
          f.description = 'Duration in seconds'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '9143c39e-c310-4947-afdf-1f4e56e5c79a'
          f.jsonKey = 'calories'
          f.name = 'Calories'
          f.description = 'Calories in kilocalories'
          f.fieldType = 'Number'
          f.event = e.id
        end
      ]
    end,
    BjondApi::BjondEvent.new.tap do |e|
      e.id = 'b6d14766-94f7-4abe-b7d5-23ee720fffff'
      e.jsonKey = 'routineEvent'
      e.name = 'Routine Event'
      e.description = 'Validic collates data that Bjond consumes'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = 'd27c8fdf-ad6d-4eb7-b5f3-99f45cb6745e'
          f.jsonKey = 'bjondPatientId'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'ee63a856-878e-4c72-8be1-464f41207fb7'
          f.jsonKey = 'steps'
          f.name = 'Steps'
          f.description = 'Number of steps'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '32705c22-fb48-49a6-9997-f2861c6c0e18'
          f.jsonKey = 'distance'
          f.name = 'Distance'
          f.description = 'Distance in meters'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '5aadd834-f88f-4442-aab2-9f9d63d7cfce'
          f.jsonKey = 'floors'
          f.name = 'Floors'
          f.description = 'Number of floors'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'c82cd944-d485-4fba-a16c-7041e7622ab6'
          f.jsonKey = 'elevation'
          f.name = 'Elevation'
          f.description = 'Elevation in meters'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'bf7b10e7-2346-4692-9cbf-ccd9052cee8e'
          f.jsonKey = 'caloriesBurned'
          f.name = 'Calories Burned'
          f.description = 'Calories burned in kilocalories'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '59b61674-c104-4ce7-89cc-76bedacc60fd'
          f.jsonKey = 'water'
          f.name = 'Water Consumption'
          f.description = 'Water consumption in ml'
          f.fieldType = 'Number'
          f.event = e.id
        end
      ]
    end,
    BjondApi::BjondEvent.new.tap do |e|
      e.id = 'aec61c4c-6100-4a61-b05b-ee1c80902c4d'
      e.jsonKey = 'nutritionEvent'
      e.name = 'Nutrition Event'
      e.description = 'Validic collates data that Bjond consumes'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = '74bd4922-ed13-4359-8949-8c64e2c3cbd6'
          f.jsonKey = 'bjondPatientId'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'e907e4f9-abbb-40c7-8c51-c99cb506fda9'
          f.jsonKey = 'calories'
          f.name = 'Calories'
          f.description = 'Calories burned in kilocalories'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'df3b81cd-f666-4384-b1dd-6157d24846dd'
          f.jsonKey = 'carbohydrates'
          f.name = 'Carbohydrates'
          f.description = 'Carbohydrates in g'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'fd097764-e6e0-4d48-a479-3b530ff03638'
          f.jsonKey = 'fat'
          f.name = 'Fat'
          f.description = 'Fat in g'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'c98d935d-bbf3-43ae-a7e5-72207553e72d'
          f.jsonKey = 'fiber'
          f.name = 'Fiber'
          f.description = 'Fiber in g'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '1ef26666-b7d6-4357-a5c5-0b35c6fb2bcc'
          f.jsonKey = 'protein'
          f.name = 'Protein'
          f.description = 'Protein in g'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '7e00776b-8202-441d-82b4-b1c6e061af47'
          f.jsonKey = 'sodium'
          f.name = 'Sodium'
          f.description = 'Sodium in mg'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'a5a379dc-2cfa-4fe3-a9d7-d8062c8e3014'
          f.jsonKey = 'water'
          f.name = 'Water'
          f.description = 'Water consumed in ml'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '1a4e540c-f69e-4cd3-bc64-6fd573357fcb'
          f.jsonKey = 'meal'
          f.name = 'Meal'
          f.description = 'The meal, for example: pizza, Coke, chicken breast, other, unspecified'
          f.fieldType = 'String'
          f.event = e.id
        end
      ]
    end,
    BjondApi::BjondEvent.new.tap do |e|
      e.id = '942a3ee7-fcf2-4b3c-b591-85de175d7383'
      e.jsonKey = 'sleepEvent'
      e.name = 'Sleep Event'
      e.description = 'Validic collates data that Bjond consumes'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = 'fa452551-1126-43b4-8861-0af997883234'
          f.jsonKey = 'bjondPatientId'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'c0372a2f-1d82-4e25-9a59-8a027eac3711'
          f.jsonKey = 'awake'
          f.name = 'Awake'
          f.description = 'Time awake in seconds'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'ed5901af-d890-432b-9649-f451b7a9e779'
          f.jsonKey = 'deep'
          f.name = 'Deep Sleep'
          f.description = 'Time in deep sleep in seconds'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '3d53d112-cd7a-4428-9b11-abce7a941cfe'
          f.jsonKey = 'light'
          f.name = 'Light Sleep'
          f.description = 'Time in light sleep in seconds'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '0098064b-7f69-4414-9de3-a2d5691e18d0'
          f.jsonKey = 'rem'
          f.name = 'REM Sleep'
          f.description = 'Time in REM sleep in seconds'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'ff3d3031-87e2-42bc-a86c-79132e3409d3'
          f.jsonKey = 'timesWoken'
          f.name = 'Times Woken'
          f.description = 'Number of times woken'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '863929c0-3c42-4f81-8162-609241faa352'
          f.jsonKey = 'totalSleep'
          f.name = 'Total Sleep'
          f.description = 'Total sleep time in seconds'
          f.fieldType = 'Number'
          f.event = e.id
        end
      ]
    end,
    BjondApi::BjondEvent.new.tap do |e|
      e.id = '32a2434a-26ff-4c70-9079-f94189decfab'
      e.jsonKey = 'sleepEvent'
      e.name = 'Sleep Event'
      e.description = 'Validic collates data that Bjond consumes'
      e.serviceId = app_def.id
      e.fields = [
        BjondApi::BjondField.new.tap do |f|
          f.id = 'cb5806e0-4204-46b7-ab91-b4b5d152461f'
          f.jsonKey = 'bjondPatientId'
          f.name = 'Patient'
          f.description = 'The patient identifier'
          f.fieldType = 'Person'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'fb0a1a30-ff42-42ec-b3c4-23e8b919bebb'
          f.jsonKey = 'weight'
          f.name = 'Weight'
          f.description = 'Weight in kg'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'bb857d95-28b1-434d-adf3-91b591b19df2'
          f.jsonKey = 'height'
          f.name = 'Height'
          f.description = 'Height in cm'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'fbf81924-aa16-4291-bb7b-9db2bf619c8f'
          f.jsonKey = 'freeMass'
          f.name = 'Free Mass'
          f.description = 'Free mass in kg'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'f46b97bd-554f-41be-b913-99b9e893545c'
          f.jsonKey = 'fatPercent'
          f.name = 'Fat Percent'
          f.description = 'Fat Percent (0-100)'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = '5ddc0242-0e5b-49d7-85bc-1e6ed558f9bc'
          f.jsonKey = 'massWeight'
          f.name = 'Mass Weight'
          f.description = 'Mass weight in kg'
          f.fieldType = 'Number'
          f.event = e.id
        end,
        BjondApi::BjondField.new.tap do |f|
          f.id = 'cbbec641-0c8c-4326-ae7b-467dab0218a5'
          f.jsonKey = 'bmi'
          f.name = 'Body Mass Index'
          f.description = 'Body mass index (kg/cm^2)'
          f.fieldType = 'Number'
          f.event = e.id
        end
      ]
    end
  ]
end
