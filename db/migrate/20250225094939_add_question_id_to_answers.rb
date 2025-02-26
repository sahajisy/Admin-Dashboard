class AddQuestionIdToAnswers < ActiveRecord::Migration[7.1]
  def change
    add_reference :answers, :question, null: false, foreign_key: true
  end
end
