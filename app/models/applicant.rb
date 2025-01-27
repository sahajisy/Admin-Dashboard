class Applicant < ApplicationRecord
  has_many :payment_histories, dependent: :destroy
  accepts_nested_attributes_for :payment_histories, allow_destroy: true

  validates :whatsapp_number, presence: true, format: { with: /\A\d{10}\z/, message: "must be 10 digits" }

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

  before_save :set_amount_based_on_jlpt_level

  def set_amount_based_on_jlpt_level
    case jlpt_level
    when 'N5'
      self.amount = 10000
    when 'N4'
      self.amount = 12000
    when 'N3'
      self.amount = 13000
    when 'N4'
      self.amount = 14000
    else
      self.amount = 0
    end
  end

end
