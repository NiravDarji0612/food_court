class Api::V1::Customer::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  # private

  # helper method to access the current user from the token
  # def current_customer
  #   @current_customer ||= Customer.find_by(id: doorkeeper_token[:resource_owner_id])
  # end
end
