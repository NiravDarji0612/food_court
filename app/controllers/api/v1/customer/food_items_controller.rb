class Api::V1::Customer::FoodItemsController < Api::V1::Customer::BaseController
  before_action :set_food_item, only: %i[show]
  def index
    category_id = params[:category_id]
    vendor_id = params[:vendor_id]

    @food_items = FoodItem.includes(vendor_category: %i[category vendor])
    @food_items = @food_items.joins(:vendor_category).where(vendor_categories: { category_id:,
                  vendor_id: })  if category_id && vendor_id
    @food_items = @food_items.joins(:vendor_category).where(vendor_categories: { category_id: })  if category_id
    @food_items = @food_items.joins(:vendor_category).where(vendor_categories: { vendor_id: }) if vendor_id

    return render json: { message: 'Food items are not present' }, status: :not_found if @food_items.empty?

    render json: { food_items: @food_items.as_json(include: { vendor_category: { include: %i[category vendor] } }), message: 'Food items have been fetched successfully' },
           status: :ok
  end

  def show
    render json: { food_item: @food_item, message: 'Food item has been fetched successfully' }, status: :ok
  end

  private

  def food_item_params
    params.require(:food_item).permit(:name, :item_type, :price, sub_type: [], taste: [], tags: [])
  end

  def set_food_item
    @food_item = FoodItem.find_by_id(params[:id])
    render json: { message: 'Food item not found' }, status: :not_found unless @food_item
  end

  # def set_vendor_category
  #   return render json: { message: "Please include the id of category"} unless params[:category_id]
  #   @vendor_category = VendorCategory.find_by(vendor_id: current_vendor.id, category_id: params[:category_id])
  # end
end
