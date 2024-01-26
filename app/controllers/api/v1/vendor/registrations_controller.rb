class Api::V1::Vendor::RegistrationsController < Api::V1::Vendor::BaseController
  skip_before_action :doorkeeper_authorize!, only: %i[sign_up]

  def sign_up
    vendor = Vendor.new(vendor_params)
    client_app = Doorkeeper::Application.find_by(uid: params[:client_id])
    return render(json: { error: 'Invalid client ID'}, status: 403) unless client_app

    if vendor.save
      render(json: {
        message: "Thank you #{vendor.first_name}, your request has been sent for the approval."
      })
    else
      render(json: { error: vendor.errors.full_messages }, status: 422)
    end
  end

  private

  def generate_refresh_token
    loop do
      # generate a random token string and return it, 
      # unless there is already another token with the same string
      token = SecureRandom.hex(32)
      break token unless Doorkeeper::AccessToken.exists?(refresh_token: token)
    end
  end 

  def vendor_params
    params.require(:vendor).permit(:first_name, :last_name, :email, :password, :phone_number, :franchise, :franchise_details, type_of_categories: [])
  end
end