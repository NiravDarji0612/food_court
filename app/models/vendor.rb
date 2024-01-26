class Vendor < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :vendor_categories, dependent: :destroy
  has_many :categories, through: :vendor_categories, dependent: :destroy

  enum :status, {
    "pending": 0,
    "approved": 1,
    "rejected": 2
  }

  def self.authenticate(email, password)
    vendor = Vendor.find_for_authentication(email: email)
    vendor&.valid_password?(password) ? vendor : nil
  end
end
