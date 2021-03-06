class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    @my_tasks = @user.tasks.all
    @my_working_tasks = @user.working_tasks.all
    @my_events = @user.events.all
  end

  def result
    @user = User.find(params[:user_id])
    # ユーザーが一致しなければ、自分のマイページに戻る（メソッドが実行されれば、その後の処理はさせない）
    return if ensure_user(@user)
    # フォームから送られてきた値を使用する（ここから）-----------------------------
    @date_range_start = params[:date_range_start].to_date
    @date_range_end = params[:date_range_end].to_date
    @events = @user.events.where(name: params[:event_name]).order(:start_date) # 複数取得し、並び替え
    @task = @user.tasks.find_by(content: params[:task_content]) # １つだけ取得
    @search_type = params[:search_type].to_i
    # フォームから送られてきた値を使用する（ここまで）-----------------------------

    # 受け取った値にエラーがないかチェックする。あったらrenderする
    if search_errors_any?
      @my_tasks = @user.tasks.all
      @my_working_tasks = @user.working_tasks.all
      @my_events = @user.events.all
      flash.now[:search_error] = t("flash.search_error")
      render 'search'
    else
      # ！！！検索開始！！！
      # 検索結果を収納する入れ物 （searched_working_tasks）を定義し、検索。最初は「全て」で検索結果に応じて徐々に絞っていくために使う。
      @searched_working_tasks = @user.working_tasks.all
      @searched_working_tasks = WorkingTask.search(@searched_working_tasks, @date_range_start, @date_range_end, @events, @task)
      # グラフに送信するためのデータ生成 ここから--------------------------------------------
      if @search_type == 1 # "合計時間を見る"
        gon.labels = []
        gon.data = []
        WorkingTask.data_for_bar_graph_SUM(@searched_working_tasks, gon.labels, gon.data)
      elsif @search_type == 2 # "平均時間を見る"
        gon.labels = []
        gon.data = []
        WorkingTask.data_for_bar_graph_AVG(@searched_working_tasks, gon.labels, gon.data)
      elsif @search_type == 3 # "流れを見る"
        gon.labels = []
        # gon.labels（横軸）に日付データを入れて、日付(range型)の始めだけを取る（横軸の見た目をすっきりさせるため）
        gon.labels = WorkingTask.get_date_array(@date_range_start, @date_range_end, @events)
        gon.labels.size.times do |i|
          gon.labels[i - 1] = gon.labels[i - 1].begin.to_date # "i"は1から始まるため、[0]から始めようとすれば -1 をする
        end
        gon.datasets = []
        WorkingTask.data_for_line_graph(@searched_working_tasks, gon.labels, gon.datasets)
      end
      # グラフに送信するためのデータ生成 ここまで--------------------------------------------
    end
  end

  private

  def search_errors_any?
    # 『エラー判定』　　　日付範囲のどちらかが空　　　　　　　　終了日が開始日より前に指定されているとき　　　　　終了日と開始日の差が80日以上のとき
    @date_range_start.nil? || @date_range_end.nil? || (@date_range_end < @date_range_start) || (@date_range_end - @date_range_start >= 80)
  end
end
