class CreateExams < ActiveRecord::Migration[7.1]
  def change
    create_table :exams do |t|
      t.string :title
      t.text :description
      t.integer :duration
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
