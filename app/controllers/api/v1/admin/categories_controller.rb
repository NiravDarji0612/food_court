class Api::V1::Admin::CategoriesController < Api::V1::Admin::BaseController
  before_action :set_category, except: %i[index create]
  skip_before_action :admin?, only: :index
  skip_before_action :doorkeeper_authorize!, only: :index
  def index
    categories = Category.all
    if categories
      render json: { categories: categories, message: "Categories has been fetched successfully" }, status: :ok
    else
      render json: { message: "No categories has found." }, status: :not_found
    end
  end

  def show
    render json: { category: @category, message: "Category has been fetched successfully" }, status: :ok
  end

  def create
    category = Category.new(category_params)
    if category.save
      render json: { category: category, message: "Category has been created successfully"}, status: :created
    else
      render json: { error: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: { category: @category, message: "Category has been updated successfully"}, status: :ok
    else
      render json: { error: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.destroy
      render json: { message: "Category has been deleted successfully"}, status: :ok
    else
      render json: { error: @category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  
  def category_params
    params.require(:category).permit(:name, :image)
  end

  def set_category
    @category = Category.find_by_id(params[:id])
    render json: { message: "category not found"}, status: :unprocessable_entity unless @category
  end
end