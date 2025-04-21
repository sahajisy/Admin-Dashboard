class Exam < ApplicationRecord
    has_many :questions, dependent: :destroy
    has_many :scores, dependent: :destroy
    has_many :applicants, through: :scores
    validates :required_jlpt_level, inclusion: { in: %w(N5 N4 N3 N2), allow_blank: true }
    validates :start_time, presence: true
    validates :end_time, presence: true

    accepts_nested_attributes_for :questions, allow_destroy: true
    def self.ransackable_associations(auth_object = nil)
        ["applicants", "questions", "scores"]
    end
    def self.ransackable_attributes(auth_object = nil)
        ["created_at", "created_by", "description", "duration", "id", "id_value", "title", "updated_at", "updated_by"]
    end
    
  end
  