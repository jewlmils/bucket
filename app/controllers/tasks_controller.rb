class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :find_category, except: [:index]
    
    # def index
    #   @pending_categories = current_user.categories.get_by_status("Pending")
    #   @completed_categories = current_user.categories.get_by_status("Completed")
      
    #   # Fetching pending tasks for all categories
    #   @pending_tasks = []
    #   @pending_categories.each do |category|
    #     @pending_tasks = category.tasks.get_by_status("Pending")
    #   end
    # end
    
  
    def new
      @task = @category.tasks.build
    end
  
    def create
      @task = @category.tasks.build(task_params)
      @task.status = "Pending"
      @task.user_id = current_user.id
      if @task.save
        @category.update_status
        redirect_to category_task_path(@category, @task)
      else
        render :new
      end
    end
  
    def show
      @task = Task.find(params[:id])
    end
  
    def edit
        @task = Task.find(params[:id])
    end
  
    def update
        @task = Task.find(params[:id])
        if @task.update(task_params)
          @category = @task.category
          @category.update_status
          redirect_to category_task_path(@category, @task)
        else
          render :edit
        end
      end
      
      
    def destroy
        @task = Task.find(params[:id])
        @task.destroy
        @category.update_status
        redirect_to category_tasks_path(@category)
    end
      
  
    private
  
    def find_category
      @category = Category.find(params[:category_id])
    end
  
    def task_params
     params.require(:task).permit(:name, :description, :category_id, :status)
    end
  end
  