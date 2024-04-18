class Api::V1::Vendor::SessionsController < Api::V1::Vendor::BaseController
  skip_before_action :doorkeeper_authorize!, only: %i[login]
  skip_before_action :vendor?, only: %i[login]
  def login
    vendor = Vendor.authenticate(vendor_params["email"], vendor_params["password"])
    client_app = Doorkeeper::Application.find_by(uid: params[:client_id])

    return render(json: { error: 'Invalid client ID'}, status: 403) unless client_app

    if vendor
      return render json: { message: "You are not authorized to perform this action yet"}, status: :unauthorized if vendor.status == "pending" || vendor.status == "rejected"

      # create access token for the vendor, so the vendor won't need to login again after registration
      access_token = Doorkeeper::AccessToken.create(
        resource_owner_id: vendor.id,
        application_id: client_app.id,
        refresh_token: generate_refresh_token,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: ''
      )

      # return json containing access token and refresh token
      # so that vendor won't need to call login API right after registration
      render(json: {
        vendor: vendor.as_json(only: [:id, :email, :first_name, :last_name, :phone_number, :razorpay_key_id, :razorpay_secret_id], include: :categories),
        access_token: access_token.token,
        token_type: 'bearer',
        expires_in: access_token.expires_in,
        refresh_token: access_token.refresh_token,
        created_at: access_token.created_at.to_time.to_i
      })
    else
      render(json: { error: "Not Found" }, status: 404)
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
    params.require(:vendor).permit(:email, :password)
  end
end
