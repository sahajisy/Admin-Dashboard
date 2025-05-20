class Exam < ApplicationRecord
  has_many :exam_questions, dependent: :destroy
  has_many :questions, through: :exam_questions

  has_many :scores, dependent: :destroy
  has_many :applicants, through: :scores

  validates :required_jlpt_level, inclusion: { in: %w(N5 N4 N3 N2), allow_blank: true }
  validates :start_time, presence: true
  validates :end_time, presence: true

  accepts_nested_attributes_for :exam_questions, allow_destroy: true

  # Add callbacks to track who creates/updates records
  before_create :set_creator
  before_update :set_updater

  def self.ransackable_associations(auth_object = nil)
    ["applicants", "questions", "scores", "exam_questions"] # Add "exam_questions" here
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "created_by", "description", "duration", "id", "id_value", "title", "updated_at", "updated_by"]
  end

  private

  def set_creator
    # Only set created_by if it's not already set
    return if self.created_by.present?

    user = Current.user || User.current_user
    if user
      self.created_by = user.try(:username) || user.try(:name) || user.try(:email)
    end
  end

  def set_updater
    # Use User instead of AdminUser
    user = Current.user || User.current_user
    if user
      self.updated_by = user.try(:username) || user.try(:name) || user.try(:email)
    end
  end
end