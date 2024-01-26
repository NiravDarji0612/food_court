class Api::V1::Customer::SessionsController < Api::V1::Customer::BaseController
  skip_before_action :doorkeeper_authorize!, only: %i[login]
  def login
    customer = Customer.find_by(email: customer_params[:email])
    client_app = Doorkeeper::Application.find_by(uid: params[:client_id])

    return render(json: { error: 'Invalid client ID'}, status: 403) unless client_app

    if customer
      # create access token for the customer, so the customer won't need to login again after registration
      access_token = Doorkeeper::AccessToken.create(
        resource_owner_id: customer.id,
        application_id: client_app.id,
        refresh_token: generate_refresh_token,
        expires_in: Doorkeeper.configuration.access_token_expires_in.to_i,
        scopes: ''
      )
      
      # return json containing access token and refresh token
      # so that customer won't need to call login API right after registration
      render(json: {
        customer: {
          id: customer.id,
          email: customer.email,
          access_token: access_token.token,
          token_type: 'bearer',
          expires_in: access_token.expires_in,
          refresh_token: access_token.refresh_token,
          created_at: access_token.created_at.to_time.to_i
        }
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

  def customer_params
    params.require(:customer).permit(:email, :password)
  end
end