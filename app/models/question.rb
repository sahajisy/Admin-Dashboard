class Question < ApplicationRecord
  belongs_to :exam
  has_many :options, dependent: :destroy
  has_many :answers, dependent: :destroy

  accepts_nested_attributes_for :options, allow_destroy: true
  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "created_by", "exam_id", "id", "id_value", "updated_at", "updated_by","category","jlpt_level"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["answers", "exam", "options"]
  end
end
