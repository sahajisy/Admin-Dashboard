class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  def self.ransackable_attributes(auth_object = nil)
    # Define a safe list of attributes that can be searched
    %w[id email created_at updated_at]
  end
  def self.ransackable_associations(auth_object = nil)
    []
  end
  validates :username, presence: true, uniqueness: { message: "Username is already taken. Please choose another." }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "Email format is invalid." }
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable

         enum role: { Admin: 0, Editor: 1, Viewer: 2 }
end
