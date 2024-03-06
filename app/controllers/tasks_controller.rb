class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :find_category
  before_action :find_task, only: [:edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
      redirect_to category_task_path(@category, @task), notice: "Task was successfully created"
    else
      render :new
    end
  end

  # Action to display details of a task
  def show
    @task = @category.tasks.find(params[:id])
  end

  # Action to render form for editing a task
  def edit
    # No need to find task here, as it's already found in find_task method
  end
  
  # Action to handle updating a task
  def update
    if @task.update(task_params)
      @category.update_status
      redirect_to category_task_path(@category, @task), notice: "Task was successfully updated"
    else
      render :edit
    end
  end

  # Action to delete a task
  def destroy
    @task.destroy
    @category.update_status
    redirect_to @task.category, notice: "Task was successfully destroyed"
  end

  private

  # Callback to find the category associated with the task
  def find_category
    @category = Category.find(params[:category_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, flash: { notice: "Category not found." }
  end

  # Callback to find the task
  def find_task
    @task = current_user.tasks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to categories_path, flash: { notice: "Task not found." }
  end

  # Strong parameters for task creation and updating
  def task_params
    params.require(:task).permit(:name, :description, :category_id, :status)
  end

  # Method to handle ActiveRecord::RecordNotFound exceptions
  def record_not_found
    redirect_to categories_path, flash: { notice: "Record not found." }
  end
end
