class CreateApplicants < ActiveRecord::Migration[7.1]
  def change
    create_table :applicants do |t|
      t.integer :serial_no
      t.string :category
      t.string :location
      t.string :programme
      t.string :college
      t.string :branch
      t.string :graduation_year
      t.string :name
      t.string :batch
      t.string :whatsapp_number
      t.string :inheritance
      t.string :a2j_id
      t.string :mail_id
      t.string :jlpt_level
      t.string :whatsapp
      t.decimal :amount
      t.decimal :balance
      t.date :admission_date
      t.string :admission_done_by
      t.string :balance_reminder
      t.string :recipt_no
      t.string :payment_mode
      t.text :remarks

      t.timestamps
    end
  end
end
