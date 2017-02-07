class ValidicConfiguration < ActiveRecord::Base
  belongs_to :bjond_registration

  def self.destroy_unused_configurations
    ValidicConfiguration.all.each do |c|
      if c.bjond_registration.nil?
        c.destroy
      end
    end
  end
end
