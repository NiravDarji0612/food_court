class Api::V1::Vendor::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :vendor?

  private

  # helper method to access the current user from the token
  def current_vendor
    @current_vendor ||= Vendor.find_by(id: doorkeeper_token[:resource_owner_id])
  end

  def vendor?
    render json: { message: "You are not authorized to perform this action"}, status: :unauthorized unless current_vendor.present?
  end
end
