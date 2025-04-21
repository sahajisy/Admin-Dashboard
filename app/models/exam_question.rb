class ExamQuestion < ApplicationRecord
    belongs_to :exam
    belongs_to :question
  
    validates :order, numericality: { only_integer: true }
  end
  