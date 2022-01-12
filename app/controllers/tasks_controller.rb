class TasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @my_tasks = Task.where(user_id: current_user.id)
  end

  def new
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @new_task = Task.new
  end

  def create
    @new_task = Task.new(task_params)
    if @new_task.save
      redirect_back(fallback_location: root_path)
    else
      @user = User.find(params[:user_id])
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to user_tasks_path
    else
      @user = User.find(current_user.id)
      render 'edit'
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy
    redirect_to user_tasks_path
  end

  def destroy_icon
    task = Task.find(params[:id])
    # 画像削除の方法は、画像idに nil を代入する
    task.update(icon_image_id: nil)
    redirect_to edit_user_task_path(task)
  end

  private
  def task_params
    params.require(:task).permit(:user_id, :icon_image, :content)
  end
end
