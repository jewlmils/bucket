class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_category, only: [:show, :edit, :update, :destroy]
  
    def index
      @empty_categories = current_user.categories.get_by_status("Empty")
      @pending_categories = current_user.categories.get_by_status("Pending")
      @completed_categories = current_user.categories.get_by_status("Completed")
    end
  
    def new
      @category = current_user.categories.build
    end
  
    def create
      @category = current_user.categories.build(category_params)
      @category.status = "Empty"
      if @category.save
        redirect_to category_path(@category)
      else
        render :new
      end
    end
  
    def show
    end
  
    def edit
    end
  
    def update
      if @category.update(category_params)
        @category.update_status
        redirect_to category_path(@category)
      else
        render :edit
      end
    end
  
    def destroy
      @category.destroy
      redirect_to categories_path
    end
  
    private
    def set_category
      @category = current_user.categories.find(params[:id])
    end
  
    def category_params
      params.require(:category).permit(:name, :description)
    end
  end
  