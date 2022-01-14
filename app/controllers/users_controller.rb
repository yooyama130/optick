class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    # 今日のタスク用----------------------------------------
    # 開始日が今日のタスクを全て取得
    @todays_working_tasks = @user.working_tasks.where(started_at: Time.current.all_day)
    # 今日のタスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    @todays_working_tasks_grouped = @todays_working_tasks.group(:task_id)

    # 最後に行ったタスク用----------------------------------------
    # 最後に行ったタスクを10個だけ取得
    @recent_working_tasks = @user.working_tasks.order(started_at: :desc).limit(10)
    # 日時を取得（working_task.rbを参照）
    @dates = WorkingTask.get_date_datas(@recent_working_tasks)

  end

  def edit
    @user = User.find(params[:id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy_image
    user = User.find(params[:id])
    # 画像削除の方法は、画像idに nil を代入する
    user.update(profile_image_id: nil)
    redirect_to edit_user_path(user)
  end

  private
  def user_params
    params.require(:user).permit(:email, :profile_image, :name)
  end
end
