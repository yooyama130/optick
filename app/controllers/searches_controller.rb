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
    # フォームから送られてきた値を使用する（ここから）-----------------------------
    @date_range_start = params[:date_range_start].to_date
    @date_range_end = params[:date_range_end].to_date
    @events = @user.events.where(name: params[:event_name]) #複数取得
    @task = @user.tasks.find_by(content: params[:task_content]) #１つだけ取得
    @search_type = params[:search_type]
    # フォームから送られてきた値を使用する（ここまで）-----------------------------

    #検索結果を収納する入れ物 （searched_working_tasks）を定義し、検索。最初は「全て」で検索結果に応じて徐々に絞っていくために使う。
    @searched_working_tasks = @user.working_tasks.all
    @searched_working_tasks = WorkingTask.search(@searched_working_tasks, @date_range_start, @date_range_end, @events, @task)

    # グラフに送信するためのデータ生成 ここから--------------------------------------------
    if @search_type == "合計時間を見る"
      gon.data_of_tasks = []
      gon.data_of_working_time = []
      WorkingTask.data_for_bar_graph_SUM(@searched_working_tasks, gon.data_of_tasks, gon.data_of_working_time)
    elsif @search_type == "平均時間を見る"
      gon.data_of_tasks = []
      gon.data_of_working_time = []
      WorkingTask.data_for_bar_graph_AVG(@searched_working_tasks, gon.data_of_tasks, gon.data_of_working_time)
    elsif @search_type == "流れを見る"
      gon.data_of_tasks = []
      gon.data_of_working_time = []
      WorkingTask.data_for_bar_graph(@searched_working_tasks, gon.data_of_tasks, gon.data_of_working_time, sum)
    end
    # グラフに送信するためのデータ生成 ここまで--------------------------------------------
  end
end
