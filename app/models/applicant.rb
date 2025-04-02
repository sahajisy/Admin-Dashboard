class Applicant < ApplicationRecord
  has_many :payment_histories, dependent: :destroy

  has_many :answers, dependent: :destroy
  has_many :scores, dependent: :destroy
  has_many :exams, through: :scores
  
  accepts_nested_attributes_for :payment_histories, allow_destroy: true

  before_save :set_amount_based_on_jlpt_level

  validates :whatsapp_number, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }
  validates :mail_id, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :jlpt_level, presence: true


  # Specify searchable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["a2j_id", "admission_date", "admission_done_by", "amount", "balance", "balance_reminder", 
     "batch", "branch", "category", "college", "created_at", "graduation_year", "id", "id_value", 
     "inheritance", "jlpt_level", "location", "mail_id", "name", "payment_mode", "programme", 
     "recipt_no", "remarks", "serial_no", "updated_at", "whatsapp", "whatsapp_number"]
  end

  # Specify searchable associations
  def self.ransackable_associations(auth_object = nil)
    ["payment_histories"] # List only associations here
  end

  def latest_balance
    payment_histories.order(payment_date: :desc).first&.balance
  end

  before_save :set_amount_based_on_jlpt_level

  def set_amount_based_on_jlpt_level
    case jlpt_level
    when 'N5'
      self.amount = 10000
    when 'N4'
      self.amount = 12000
    when 'N3'
      self.amount = 13000
    when 'N2'
      self.amount = 14000
    else
      self.amount = 0
    end
  end

end
