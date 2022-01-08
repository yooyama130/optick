require 'test_helper'

class WorkingTasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get working_tasks_index_url
    assert_response :success
  end

  test "should get new" do
    get working_tasks_new_url
    assert_response :success
  end

  test "should get edit" do
    get working_tasks_edit_url
    assert_response :success
  end

end
