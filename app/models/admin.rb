class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.authenticate(email, password)
    admin = Admin.find_for_authentication(email: email)
    admin&.valid_password?(password) ? admin : nil
  end
end
