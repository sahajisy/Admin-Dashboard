class Score < ApplicationRecord
  belongs_to :exam
  belongs_to :applicant
  def self.ransackable_attributes(auth_object = nil)
    ["applicant_id", "created_at", "exam_id", "id", "id_value", "score", "updated_at"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["applicant", "exam"]
  end
end
