class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Action to list categories
  def index
    # Fetching categories by status for the current user
    # @empty_categories = current_user.categories.get_by_status("Empty")
    # @pending_categories = current_user.categories.get_by_status("Pending")
    # @completed_categories = current_user.categories.get_by_status("Completed")
    # @categories = current_user.categories.all
    # # Fetching pending tasks for the current user
    # @pending_tasks = current_user.tasks.where(status: "Pending")
    @priority_tasks = current_user.tasks.where(status: "Priority")
    @categories = current_user.categories.all.order(created_at: :desc)
  end

  # Action to render form for creating a new category
  def new
    @category = current_user.categories.build
  end

  # Action to handle creation of a new category
  def create
    @category = current_user.categories.build(category_params)
    @category.status = "Empty"
    if @category.save
      redirect_to category_path(@category), notice: "Category was successfully created"
    else
      render :new
    end
  end

  # Action to display details of a category
  def show
  end

  # Action to render form for editing a category
  def edit
    # No specific logic here as we're only rendering the edit form
  end

  # Action to handle updating a category
  def update
    if @category.update(category_params)
      @category.update_status
      redirect_to category_path(@category), notice: "Category was successfully updated"
    else
      render :edit
    end
  end

  # Action to delete a category
  def destroy
    @category.tasks.destroy_all
    @category.destroy
    redirect_to categories_path, notice: "Category was successfully destroyed"
  end

  private

  # Callback to set the category based on the ID parameter
  def set_category
    @category = current_user.categories.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, flash: { notice: "Category not found." } 
  end

  # Strong parameters for category creation and updating
  def category_params
    params.require(:category).permit(:name, :description)
  end
end

#TODO: TEST, Name/Username Sign up and log in