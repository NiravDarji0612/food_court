class Api::V1::Vendor::FoodItemsController < Api::V1::Vendor::BaseController
  before_action :set_food_item, except: %i[create index]
  before_action :set_vendor_category, only: %i[create]
  def index
    if params[:category_name].present?
      category = Category.find_by_name(params[:category_name])
      @food_items = FoodItem.joins(:vendor_category).where(vendor_categories: { category_id: category&.id, vendor_id: current_vendor.id })
    else
      @food_items = FoodItem.joins(:vendor_category).where(vendor_categories: { vendor_id: current_vendor.id })
    end
    @food_items = @food_items.map{|food_item| food_item.attributes.merge({category_name: food_item&.vendor_category&.category&.name})}
    return render json: { message: "Food items are not present"}, status: :not_found unless @food_items.present?

    render json: { food_items: @food_items, message: "Food items has been fetched successfully"}, status: :ok
  end

  def create
    food_item = FoodItem.new(food_item_params)
    food_item.vendor_category = @vendor_category
    if food_item.save
      render json: { food_item: food_item, message: "Food item has been created successfully"}, status: :created
    else
      render json: { message: food_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { food_item: @food_item, message: "Food item has been fetched successfully"}, status: :ok
  end

  def update
    if @food_item.update(food_item_params)
      render json: { food_item: @food_item, message: "Food item has been updated successfully"}, status: :ok
    else
      render json: { message: @food_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @food_item.destroy
      render json: { message: "Food item has been removed successfully"}, status: :ok
    else
      render json: { message: @food_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def food_item_params
    params.require(:food_item).permit(:name, :item_type, :price, sub_type: [], taste: [], tags: [])
  end

  def set_food_item
    @food_item = FoodItem.find_by_id(params[:id])
    return render json: { message: "Food item not found"}, status: :not_found unless @food_item
  end

  def set_vendor_category
    return render json: { message: "Please include the id of category"} unless params[:category_id]
    @vendor_category = VendorCategory.find_by(vendor_id: current_vendor.id, category_id: params[:category_id])
  end
end
