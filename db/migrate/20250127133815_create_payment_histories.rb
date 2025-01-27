class CreatePaymentHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_histories do |t|
      t.string :jlpt_level
      t.decimal :payable_amount
      t.decimal :paid_amount
      t.date :payment_date
      t.string :updated_by

      t.timestamps
    end
  end
end
