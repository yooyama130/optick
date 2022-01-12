class WorkingTasksController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def new
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @my_tasks = Task.where(user_id: current_user.id)
  end

  def create
  end

  def edit
  end

  def update
  end
end
