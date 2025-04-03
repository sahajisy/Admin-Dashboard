class AddCategoryToQuestions < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :category, :string
  end
end
