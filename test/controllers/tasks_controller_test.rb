require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:one)
    @task = tasks(:one)
  end

  test "should get index" do
    get :index, :user_id => users(:one).id
    assert_response :success
    assert_not_nil assigns(:tasks)
  end

  test "should get new" do
    get :new, :user_id => users(:one).id
    assert_response :success
  end

  test "should create task" do
    assert_difference('Task.count') do
      post :create, task: { completed: @task.completed, completed_date: @task.completed_date, completed_user_id: @task.completed_user_id, due_date: @task.due_date, due_time: @task.due_time, name: @task.name, note: @task.note },
      :user_id => users(:one).id
    end

    assert_redirected_to task_path(assigns(:task))
  end

  test "should show task" do
    get :show, id: @task, :user_id => users(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @task, :user_id => users(:one).id
    assert_response :success
  end

  test "should update task" do
    patch :update, id: @task, task: { completed: @task.completed, completed_date: @task.completed_date, completed_user_id: @task.completed_user_id, due_date: @task.due_date, due_time: @task.due_time, name: @task.name, note: @task.note },
    :user_id => users(:one).id
    assert_redirected_to task_path(assigns(:task))
  end

  test "should destroy task" do
    assert_difference('Task.count', -1) do
      delete :destroy, id: @task, :user_id => users(:one).id
    end

    assert_redirected_to tasks_path
  end
end
