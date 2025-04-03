class AddRequiredJlptLevelToExams < ActiveRecord::Migration[7.1]
  def change
    add_column :exams, :required_jlpt_level, :string
  end
end
