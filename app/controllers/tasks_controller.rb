class TasksController < ApplicationController
    before_action :authenticate_user!
    before_action :find_category
    
    def index
      @pending_tasks = @category.tasks.get_by_status("Pending")
      @completed_tasks = @category.tasks.get_by_status("Completed")
    end
  
    def new
      @task = @category.tasks.build
    end
  
    def create
      @task = @category.tasks.build(task_params)
      @task.status = "Pending"
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
  