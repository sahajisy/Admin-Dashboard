class ExamQuestion < ApplicationRecord
    belongs_to :exam
    belongs_to :question
  
    validates :order, numericality: { only_integer: true }
    def self.ransackable_attributes(auth_object = nil)
      ["created_at", "exam_id", "id", "id_value", "order", "question_id", "updated_at"]
    end
  end
  