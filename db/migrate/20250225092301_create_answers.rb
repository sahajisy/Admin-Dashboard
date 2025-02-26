class CreateAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :answers do |t|
      t.text :content
      t.boolean :correct
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
