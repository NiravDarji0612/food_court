class HomeController < ApplicationController
  def index
    render json: { message: "welcome to food court api application"}, status: :ok
  end

  def check_thread
    render json: { message: 'Request processed', thred_details: Thread.current.object_id }
  end
end
