class TasksController < ApplicationController
  def index
    @user = User.find(current_user.id)
    @my_tasks = Task.where(user_id: current_user.id)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
end
