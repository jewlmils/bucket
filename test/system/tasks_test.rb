require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    @user = users(:user_one)
    @category = categories(:category_one)
    @task = tasks(:task_one)
    login
  end

  test 'creates a new task' do
    visit_category_page
    click_on "Add Task"

    fill_in_task_form("Hello Test", "Hello Test Desc")
    click_on "Create Task"

    assert_text "Task was successfully created"
  end

  test 'updates a task' do
    visit_category_page
    find("a[href='#{edit_category_task_path(@category, @task)}']").click

    fill_in_task_form("#{@task.name}edit-test", "#{@task.description}edit-test")
    select "Completed", from: "Status" 
    click_on "Update Task"

    assert_text "Task was successfully updated."
  end

  test 'destroy a task' do
    visit_category_page

    accept_confirm do
      find("a[href='#{category_task_path(@category, @task)}'][data-turbo-method='delete']").click
    end

    assert_text "Task was successfully deleted."
  end

  private

  def login
    visit root_path
    click_on "Log in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: "hello123"
    click_on "Submit"

    assert_text "Log out"
  end

  def visit_category_page
    visit root_path
    click_on @category.name
  end

  def fill_in_task_form(name, description)
    fill_in "Name", with: name
    fill_in "Description", with: description
  end
end
