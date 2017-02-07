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
    end
  ]
end
