require 'application_system_test_case'

class CategoriesTest < ApplicationSystemTestCase
  setup do
    @user = users(:user_one)
    @category = categories(:category_one)
    login
  end

  test 'visiting the index' do
    visit root_path
    assert_selector 'h1', text: "Welcome to your Bucket #{@user.email}"
  end

  test 'creates a new category' do
    visit root_path
    click_on "Create Bucket"

    fill_in_category_form("Hello Test", "Hello Test Desc")
    click_on "Create Category"

    assert_text "Category was successfully created"
  end

  test 'updates a category' do
    visit root_path
    click_on "Edit"

    fill_in_category_form("#{@category.name}edit-test", "#{@category.description}edit-test")
    click_on "Update Category"

    assert_text "Category was successfully updated"
  end

  test 'destroy a category' do
    visit root_path

    accept_confirm do
      click_on "Delete", match: :first
    end

    assert_text "Category was successfully deleted."
  end

  test 'view a category' do
    click_on @category.name
    assert_text "#{@category.name}"
  end

  private
  
  def login
    visit root_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "hello123"
    click_on "Submit"

    assert_text "Log out"
  end

  def fill_in_category_form(name, description)
    fill_in "Name", with: name
    fill_in "Description", with: description
  end
end