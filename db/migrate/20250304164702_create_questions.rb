class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :content
      t.references :exam, null: false, foreign_key: true
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
