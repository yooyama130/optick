class TasksController < ApplicationController
  def index
    @user = User.find(current_user.id)
    @my_tasks = Task.where(user_id: current_user.id)
  end

  def new
    @user = User.find(current_user.id)
    @new_task = Task.new
  end

  def create
    @new_task = Task.new(task_params)
    if @new_task.save
      redirect_to user_tasks_path
    else
      @user = User.find(current_user.id)
      render 'new'
    end
  end

  def edit
  end

  def update
  end

  private
  def task_params
    params.require(:task).permit(:user_id, :icon_image, :content)
  end
end
