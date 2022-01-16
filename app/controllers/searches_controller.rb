class SearchesController < ApplicationController
  def top
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @my_tasks = @user.tasks.all
    @my_working_tasks = @user.working_tasks.all
    @my_events = @user.events.all
  end

  def result
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る
    redirect_to user_path(current_user) unless @user == current_user
    @my_working_tasks = @user.working_tasks.all
    # フォームから送られてきた値を使用する（ここから）-----------------------------
    date_range_start = params[:date_range_start].to_date
    date_range_end = params[:date_range_end].to_date
    events = @user.events.where(name: params[:event_name]) #複数取得
    task = @user.tasks.find_by(content: params[:task_content]) #１つだけ取得
    # フォームから送られてきた値を使用する（ここまで）-----------------------------

    #検索結果を収納する入れ物 （searched_working_tasks）を定義し、検索。最初は「全て」で検索結果に応じて徐々に絞っていくために使う。
    @searched_working_tasks = @user.working_tasks.all
    @searched_working_tasks = WorkingTask.search(@searched_working_tasks, date_range_start, date_range_end, events, task)
    # タスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    @searched_working_tasks_grouped = @searched_working_tasks.group(:task_id)

    # グラフに送信するためのデータ生成 ここから--------------------------------------------
    gon.data_of_tasks_for_search = []
    gon.data_of_working_time_sums_for_search = []
    @searched_working_tasks_grouped.each do |working_task|
      gon.data_of_tasks_for_search << working_task.task.content
      gon.data_of_working_time_sums_for_search << @searched_working_tasks.where(task_id: working_task.task_id).pluck(:working_time).sum
    end
    # グラフに送信するためのデータ生成 ここまで--------------------------------------------
  end
end
