class PaymentHistory < ApplicationRecord
    belongs_to :applicant

    def self.ransackable_attributes(auth_object = nil)
      ["applicant_id", "created_at", "id", "id_value", "jlpt_level", "paid_amount", "payable_amount", "payment_date", "updated_at", "updated_by"]
    end

    def balance
      (payable_amount || 0) - (paid_amount || 0)
    end
  
    private
  
    def set_default_values
      self.payable_amount ||= 0
      self.paid_amount ||= 0
    end  
end
