class Api::V1::Admin::FoodItemsController < Api::V1::Admin::BaseController
  def index
    food_items = FoodItem.all
    if food_items
      render json: { food_items: food_items, message: "Food items has been fetched successfully"}, status: :ok
    else
      render json: { message: "Food items are not present"}, status: :not_found
    end
  end
end