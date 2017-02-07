class AddSamplePersonIdToValidicConfiguration < ActiveRecord::Migration
  def change
    add_column :validic_configurations, :sample_person_id, :string
  end
end