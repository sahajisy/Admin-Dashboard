class AddJlptLevelToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :jlpt_level, :string
  end
end
