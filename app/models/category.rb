class Category < ApplicationRecord
  has_many :vendor_categories, dependent: :destroy
  has_many :vendors, through: :vendor_categories, dependent: :destroy
  
  has_one_attached :image

  validates :name, presence: true, uniqueness: true
end
