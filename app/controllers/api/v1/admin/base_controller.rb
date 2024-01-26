class Api::V1::Admin::BaseController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :admin?

  private

  # helper method to access the current user from the token
  def current_admin
    @current_admin ||= Admin.find_by(id: doorkeeper_token[:resource_owner_id])
  end

  def admin?
    render json: { message: "You are not authorized to perform this action"}, status: :unauthorized unless current_admin.present?
  end
end
