class CreateJoinTableExamsQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :exam_questions do |t|
      t.references :exam, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.integer :order, null: false, default: 0

      t.timestamps
    end
  end
end
