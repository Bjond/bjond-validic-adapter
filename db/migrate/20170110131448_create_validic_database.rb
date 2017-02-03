class CreateValidicDatabase < ActiveRecord::Migration
  def change
	  create_table :bjond_registrations do |t|
	    t.string   :server
	    t.string   :encrypted_encryption_key
	    t.string   :encrypted_encryption_key_iv
	    t.string   :host
	    t.string   :ip

	    t.timestamps null: false
	  end

	  create_table :bjond_services do |t|
	    t.string   :group_id
	    t.string   :endpoint
	    t.string   :bjond_registration_id

	    t.timestamps null: false
	  end

	  create_table :validic_configurations do |t|
	    t.string   :api_key
	    t.string   :secret
	    t.string   :bjond_registration_id

	    t.timestamps null: false
	  end

	  create_table :bjond_validic_user_conversions do |t|
	    t.string   :validic_id
	    t.string   :bjond_id
	    t.string   :user_access_token
	    
	    t.timestamps null: false
	  end
  end
end