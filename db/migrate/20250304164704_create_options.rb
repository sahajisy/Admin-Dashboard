class CreateOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :options do |t|
      t.string :content
      t.boolean :correct
      t.references :question, null: false, foreign_key: true
      t.string :created_by
      t.string :updated_by

      t.timestamps
    end
  end
end
