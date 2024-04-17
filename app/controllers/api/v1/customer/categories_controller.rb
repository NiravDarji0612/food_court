class Api::V1::Customer::CategoriesController < Api::V1::Customer::BaseController
  before_action :set_category, except: %i[index]
  def index
    categories = Category.includes(vendors: [stall_logo_attachment: :blob])
    categories = categories.map do |cat|
      cat.attributes.merge({ image: url_for(cat&.image), vendors: cat.vendors })
    end
    if categories
      render json: { categories: categories, message: "Categories has been fetched successfully" }, status: :ok
    else
      render json: { message: "No categories has found." }, status: :not_found
    end
  end

  def show
    @category = @category.map do |cat|
      cat.attributes.merge({ vendors: cat.vendors })
    end
    render json: { category: @category, message: "Category has been fetched successfully" }, status: :ok
  end

  private

  def category_params
    params.require(:category).permit(:name, :image)
  end

  def set_category
    @category = Category.includes(:vendors).find_by_id(params[:id])
    render json: { message: "category not found"}, status: :unprocessable_entity unless @category
  end
end
