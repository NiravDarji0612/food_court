class HomeController < ApplicationController
  def index
    render json: { message: "welcome to food court api application"}, status: :ok
  end
end