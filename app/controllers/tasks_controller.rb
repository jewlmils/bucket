class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_category
  before_action :set_task, only: [:edit, :update, :destroy]

  def new
    @task = @category.tasks.build
  end

  def create
    @task = @category.tasks.build(task_params)
    @task.status = "Pending"
    @task.user_id = current_user.id
    if @task.save
      @category.update_status
      redirect_to @task.category, notice: "Task was successfully created."
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
      redirect_to @task.category, notice: "Task was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    @category.update_status
    redirect_to @task.category, notice: "Task was successfully deleted."
  end

  private

  # Sets the category based on the provided category_id parameter
  def set_category
    @category = Category.find(params[:category_id])
  end

  # Sets the task based on the provided id parameter
  def set_task
    @task = current_user.tasks.find(params[:id])
  end

  # Defines permitted parameters for task creation and updating
  def task_params
    params.require(:task).permit(:name, :description, :category_id, :status)
  end
end