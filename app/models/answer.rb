class Answer < ApplicationRecord
  belongs_to :applicant
  belongs_to :question
  belongs_to :option

  def self.ransackable_associations(auth_object = nil)
    ["applicant", "option", "question"]
  end
  def self.ransackable_attributes(auth_object = nil)
    ["applicant_id", "created_at", "created_by", "id", "id_value", "option_id", "question_id", "updated_at", "updated_by"]
  end
end
