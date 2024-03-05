class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.authenticate(email, password)
    customer = Customer.find_for_authentication(email: email)
    customer&.valid_password?(password) ? customer : nil
  end

  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy
end
