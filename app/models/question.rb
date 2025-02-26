class Question < ApplicationRecord
    has_and_belongs_to_many :exams
    has_many :answers, dependent: :destroy
  
    accepts_nested_attributes_for :answers, allow_destroy: true
    def self.ransackable_attributes(auth_object = nil)
        ["content", "created_at", "created_by", "id", "id_value", "updated_at", "updated_by"]
    end
    def self.ransackable_associations(auth_object = nil)
        ["answers", "exams"]
    end
  end
  