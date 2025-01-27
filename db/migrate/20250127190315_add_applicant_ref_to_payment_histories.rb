class AddApplicantRefToPaymentHistories < ActiveRecord::Migration[7.1]
  def change
    add_reference :payment_histories, :applicant, null: false, foreign_key: true
  end
end
