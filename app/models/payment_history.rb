class PaymentHistory < ApplicationRecord
    belongs_to :applicant

    before_validation :set_payable_amount_from_previous_balance, on: :create

    def self.ransackable_attributes(auth_object = nil)
      ["applicant_id", "created_at", "id", "id_value", "jlpt_level", "paid_amount", "payable_amount", "payment_date", "updated_at", "updated_by"]
    end

    def balance
      (payable_amount || 0) - (paid_amount || 0)
    end
  
    private

    def set_payable_amount_from_previous_balance
      last_payment_history = applicant.payment_histories.order(payment_date: :desc).first
      self.payable_amount = last_payment_history.balance if last_payment_history.present?
    end
  
    def set_updated_by_user
      self.updated_by = applicant.user.email if applicant.user.present?
    end

    def set_default_values
      self.payable_amount ||= 0
      self.paid_amount ||= 0
    end  
end
