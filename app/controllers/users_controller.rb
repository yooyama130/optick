class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    # 開始日が今日のタスクを全て取得
    today = Time.current
    @todays_working_tasks = @user.working_tasks.where(being_measured?: false, started_at: today.all_day)
    # 今日のタスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    @todays_working_tasks_grouped = @todays_working_tasks.group(:task_id)

    # 計測中のタスクを表示する
    @working_tasks_measuring = @user.working_tasks.where(being_measured?: true)

    # カレンダー用 ここから----------------------------------------------------------------
    @my_tasks = @user.tasks.all
    # タスクのフィルタリングがあれば指定されたものだけ。なければ全て取得
    if params[:task_filtered].present?
      task_filtered = Task.find_by(content: params[:task_filtered])
      @my_working_tasks = @user.working_tasks.where(task_id: task_filtered.id)
    else
      @my_working_tasks = @user.working_tasks.all
    end
    @my_events = @user.events.all
    # カレンダー用 ここまで----------------------------------------------------------------

    # グラフに送信するためのデータ生成 ここから--------------------------------------------
    gon.labels = []
    gon.data = []
    WorkingTask.data_for_doughnut_graph(@todays_working_tasks, gon.labels, gon.data)
    # グラフに送信するためのデータ生成 ここまで--------------------------------------------
  end

  def edit
    @user = User.find(params[:id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
  end

  def update
    @user = User.find(params[:id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def destroy_image
    user = User.find(params[:id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(user)
    # 画像削除の方法は、画像idに nil を代入する
    user.update(profile_image_id: nil)
    redirect_to edit_user_path(user)
  end

  # フォーム画面でエラーメッセージが出たときに更新するとエラー出るのを防止（route.rb参照）
  def back_to_form
    redirect_back(fallback_location: root_path)
  end

  private

  def user_params
    params.require(:user).permit(:email, :profile_image, :name)
  end
end
