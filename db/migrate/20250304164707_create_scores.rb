class CreateScores < ActiveRecord::Migration[7.1]
  def change
    create_table :scores do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :applicant, null: false, foreign_key: true
      t.integer :score

      t.timestamps
    end
  end
end
