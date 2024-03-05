class Api::V1::Customer::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  private

  def current_customer
    @current_customer ||= Customer.find_by(id: doorkeeper_token[:resource_owner_id])
  end

  def customer?
    render json: { message: "You are not authorized to perform this action"}, status: :unauthorized unless current_customer.present?
  end
end
