class Customer < ActiveRecord::Base
  def measurements
    Measurement.where(customer_id: self.id)[0]
  end
end
