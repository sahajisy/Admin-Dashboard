class Option < ApplicationRecord
  belongs_to :question
  def self.ransackable_associations(auth_object = nil)
    ["question"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["content", "correct", "created_at", "created_by", "id", "id_value", "question_id", "updated_at", "updated_by"]
  end
end
