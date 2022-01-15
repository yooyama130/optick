class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    # 開始日が今日のタスクを全て取得
    today = Time.current
    @todays_working_tasks = @user.working_tasks.where(being_measured?: false, started_at: today.all_day)
    # 今日のタスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    @todays_working_tasks_grouped = @todays_working_tasks.group(:task_id)

    # 計測中のタスクを表示する
    @working_tasks_measuring = @user.working_tasks.where(being_measured?: true)

    # カレンダー用 ここから----------------------------------------------------------------
    @my_working_tasks = @user.working_tasks.all
    @my_events = @user.events.all
    # カレンダー用 ここまで----------------------------------------------------------------

    # グラフに送信するためのデータ生成 ここから--------------------------------------------
    gon.data_of_tasks = []
    gon.data_of_working_time_sums = []
    @todays_working_tasks_grouped.each do |working_task|
      gon.data_of_tasks << working_task.task.content
      gon.data_of_working_time_sums << @todays_working_tasks.where(task_id: working_task.task_id).pluck(:working_time).sum
    end
    # グラフに送信するためのデータ生成 ここまで--------------------------------------------
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
