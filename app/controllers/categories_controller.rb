class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @empty_categories = current_user.categories.get_by_status("Empty")
    @pending_categories = current_user.categories.get_by_status("Pending")
    @completed_categories = current_user.categories.get_by_status("Completed")
    @priority_tasks = current_user.tasks.where(status: "Priority")
    @categories = current_user.categories.all.order(created_at: :desc)
  end

  def new
    @category = current_user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    @category.status = "Empty"
    if @category.save
      redirect_to category_path(@category), notice: "Category was successfully created."
    else
      if @category.errors[:name].include?("has already been taken")
        flash[:alert] = "Category name has already been taken."
      end
      redirect_to root_path
    end
  end  

  def show
  end

  def edit
  end

  def update
    if @category.update(category_params)
      @category.update_status
      redirect_to category_path(@category), notice: "Category was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @category.tasks.destroy_all
    @category.destroy
    redirect_to root_path, notice: "Category was successfully deleted."
  end

  private

  # Sets the category based on the provided id parameter
  def set_category
    @category = current_user.categories.find(params[:id])
  end

  # Defines permitted parameters for category creation and updating
  def category_params
    params.require(:category).permit(:name, :description)
  end
end