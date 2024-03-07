class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_category
  before_action :find_task, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def new
    @task = @category.tasks.build
  end

  def create
    @task = @category.tasks.build(task_params)
    @task.status = "Pending"
    @task.user_id = current_user.id
    if @task.save
      @category.update_status
      redirect_to @task.category, notice: "Task was successfully created"
    else
      render :new
    end
  end

  def show
    @task = @category.tasks.find(params[:id])
  end

  
  def edit
  end
 
  def update
    if @task.update(task_params)
      @category.update_status
      redirect_to @task.category, notice: "Task was successfully updated"
    else
      render :edit
    end
  end

  
  def destroy
    @task.destroy
    @category.update_status
    redirect_to @task.category, notice: "Task was successfully destroyed"
  end

  private

  def find_category
    @category = Category.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, flash: { notice: "Category not found." }
  end

  def find_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, flash: { notice: "Task not found." }
  end

  def task_params
    params.require(:task).permit(:name, :description, :category_id, :status)
  end

  def record_not_found
    redirect_to categories_path, flash: { notice: "Record not found." }
  end
end
