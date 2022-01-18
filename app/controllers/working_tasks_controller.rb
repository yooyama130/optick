class WorkingTasksController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    # その日に行ったタスクを取得
    @date = params[:date].to_date
    @working_tasks = @user.working_tasks.where(being_measured?: false, started_at: @date.all_day).order(started_at: :desc)
    # その日に「つけられているタグ」を取得
    # 取得されている@dateが start_date以上かつend_date以下（start_dateとend_dateの間）にあるものだけ取得
    @events = @user.events.where('start_date <= ? and  ? <= end_date', @date, @date)
  end

  def new
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @my_tasks = Task.where(user_id: current_user.id)
  end

  def set
    # ----------------------------------------------ここから----------------------------------------
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @my_tasks = Task.where(user_id: current_user.id)
    # ----------------------------------------------ここまでは上のnewと一緒-------------------------
    @selected_task = Task.find(params[:task_id])
  end

  def start
    user = User.find(params[:user_id])
    selected_task = Task.find(params[:task_id])
    # 現在時刻を取得し、開始時間（started_at）に代入
    now = Time.current
    WorkingTask.create(user_id: user.id, task_id: selected_task.id, started_at: now)
    redirect_to user_set_new_working_task_path(user, selected_task)
  end

  def stop
    user = User.find(params[:user_id])
    selected_task = Task.find(params[:task_id])
    working_task = WorkingTask.find_by(user_id: user.id, task_id: selected_task.id, being_measured?: true)
    # 現在時刻を取得し、終了時間（started_at）に代入し、being_measured?（計測中？）をfalseにする
    now = Time.current
    working_task.update(stopped_at: now, being_measured?: false)
    # 経過時間を終了時間 - 開始時間 で　出す
    working_time = working_task.stopped_at - working_task.started_at
    working_task.update(working_time: working_time)
    redirect_to new_user_working_task_path(user)
  end

  def edit
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    @working_task = WorkingTask.find(params[:id])
  end

  def update
    @user = User.find(params[:user_id])
    @working_task = WorkingTask.find(params[:id])
    if @working_task.update(working_task_params)
      # 経過時間を更新
      @working_task.update(working_time: (@working_task.stopped_at - @working_task.started_at))
      # 編集したタスクのある日付で一覧を表示させる
      redirect_to user_working_tasks_path(@user, @working_task.started_at.to_date)
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:user_id])
    working_task = WorkingTask.find(params[:id])
    working_task.destroy
    # 削除したタスクのある日付で一覧を表示させる
    redirect_to user_working_tasks_path(user, working_task.started_at.to_date)
  end

  private

  def working_task_params
    params.require(:working_task).permit(:started_at, :stopped_at)
  end
end
