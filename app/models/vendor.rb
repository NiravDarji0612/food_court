class Vendor < ApplicationRecord
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :vendor_categories, dependent: :destroy
  has_many :categories, through: :vendor_categories, dependent: :destroy
  has_one_attached :stall_logo
  has_many :orders, dependent: :destroy
  # has_one :business_information, dependent: :destroy

  normalizes :stall_name, with: ->(name) { name.titleize }

  enum :status, {
    "pending": 0,
    "approved": 1,
    "rejected": 2
  }

  def as_json(options = {})
    super(options).merge(stall_logo_url: stall_logo.attached? ? url_for(stall_logo) : '')
  end

  def self.authenticate(email, password)
    vendor = Vendor.find_for_authentication(email:)
    vendor&.valid_password?(password) ? vendor : nil
  end
end
