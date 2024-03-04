class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_category
  before_action :find_task, only: [:edit, :update, :destroy]

  # Action to render form for creating a new task
  def new
    @task = @category.tasks.build
  end

  # Action to handle creation of a new task
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

  # Action to display details of a task
  def show
    @task = @category.tasks.find_by(id: params[:id])
  end

  # Action to render form for editing a task
  def edit
    @task = Task.find_by(id: params[:id])
    unless @task
      flash[:error] = "Task not found."
      redirect_to root_path
    end
  end
  
  # Action to handle updating a task
  def update
    if @task.update(task_params)
      @category = @task.category
      @category.update_status
      redirect_to category_task_path(@category, @task)
    else
      render :edit
    end
  end

  # Action to delete a task
  def destroy
    @task.destroy
    @category.update_status
    redirect_to @task.category
  end

  private

  # Callback to find the category associated with the task
  def find_category
    @category = Category.find_by(id: params[:category_id])
    redirect_to root_path, flash[:error] = "Category not found." unless @category
  end

  # Callback to find the task
  def find_task
    @task = current_user.tasks.find_by(id: params[:id])
  end

  # Strong parameters for task creation and updating
  def task_params
    params.require(:task).permit(:name, :description, :category_id, :status)
  end
end
