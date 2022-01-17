class WorkingTask < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :started_at, presence: true, if: :not_being_measured?
  validates :stopped_at, presence: true, if: :not_being_measured?


  # 「計測中がfalseのとき」の条件式
  def not_being_measured?
    being_measured? == false
  end


  # 『記録済みタスクを調べる』機能に使う
  def self.search(container, date_range_start, date_range_end, events, task)
    # 1.最初にstarted_atが検索フォームから送られてきた日付範囲に入っているかを検索。
    #   タグ指定があれば、started_atがフォームから送られてきたタグの日付範囲に入っているものだけを取得
    container = container.where(started_at: WorkingTask.get_date_array(date_range_start, date_range_end, events))
    # 2.タスク指定があれば、1、2で取得したものからさらに、フォームから送られてきたタスクのidのものだけ取得
    if task.present?
      container = container.where(task_id: task.id)
    end
    container
  end

  # 2つの日付範囲内の日付を配列に入れる。タグがあればタグの日付範囲内の日付を配列に入れる
  def self.get_date_array(date_range_start, date_range_end, events)
    # 下のeachメソッドで使う配列を定義
    date_array = []
    if events.exists?
      # タグの日付範囲内の日付を配列に入れていく
      events.each do |event|
        (event.start_date..event.end_date).each do |date|
          date_array << date.all_day
        end
      end
    else
      # 日付範囲内の日付を配列に入れていく
      (date_range_start..date_range_end).each do |date|
        date_array << date.all_day
      end
    end
    date_array
  end

  # 2つの日付範囲内の日付を配列に入れる。タグがあればタグの日付範囲内の日付を配列に入れる
  def self.get_date_array(date_range_start, date_range_end, events)
    # 下のeachメソッドで使う配列を定義
    date_array = []
    if events.exists?
      # タグの日付範囲内の日付を配列に入れていく
      events.each do |event|
        (event.start_date..event.end_date).each do |date|
          date_array << date.all_day
        end
      end
    else
      # 日付範囲内の日付を配列に入れていく
      (date_range_start..date_range_end).each do |date|
        date_array << date.all_day
      end
    end
    date_array
  end


  # ----------------------------------------グラフデータ送信用-------------------------------------------------------------------------------------------
  # 棒グラフ（合計値）
  def self.data_for_bar_graph_SUM(working_tasks, labels, data)
    # タスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    working_tasks_grouped = working_tasks.group(:task_id)
    working_tasks_grouped.each do |grouped|
      # タスクの種類だけ処理を繰り返す。
      # labels（横軸）は、タスクの名前。data（縦軸）にはタスクの種類ごとのworking_timeを計算するための『合計』を入れる。（60で割って、分単位にする）
      labels << grouped.task.content
      data << working_tasks.where(task_id: grouped.task_id).pluck(:working_time).sum / 60
    end
  end

  # 棒グラフ（平均値）
  def self.data_for_bar_graph_AVG(working_tasks, labels, data)
    # タスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    working_tasks_grouped = working_tasks.group(:task_id)
    working_tasks_grouped.each do |grouped|
      # タスクの種類だけ処理を繰り返す。
      # labels（横軸）は、タスクの名前。
      # data（縦軸）にはタスクの種類ごとのworking_timeを計算するための『平均』を入れる。（60で割って、分単位にする）
      labels << grouped.task.content
      data << (working_tasks.where(task_id: grouped.task_id).pluck(:working_time).sum) / (working_tasks.where(task_id: grouped.task_id).pluck(:working_time).length)   / 60
    end
  end

  # 円グラフ
  def self.data_for_doughnut_graph(working_tasks, labels, data)
    # タスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    working_tasks_grouped = working_tasks.group(:task_id)
    working_tasks_grouped.each do |grouped|
      # タスクの種類だけ処理を繰り返す。
      # labels（データの名前）にはタスクの名前を入れる。data（データの量・割合）にはタスクの種類ごとのworking_timeの『合計』を入れる（秒単位のまま）
      labels << grouped.task.content
      data << working_tasks.where(task_id: grouped.task_id).pluck(:working_time).sum
    end
  end

  # 折れ線
  def self.data_for_line_graph(working_tasks, labels, datasets)
    # labels（横軸）はあらかじめ代入して使っている。
    # タスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    working_tasks_grouped = working_tasks.group(:task_id)
    working_tasks_grouped.each do |grouped|
      # タスクの種類だけ処理を繰り返す
      # まず、working_timesを定義・初期化する
      working_times = []
      labels.each do |date|
        # 日付がある分だけ、「その日のタスクの実働時間の合計」を取り出していく
        working_times << working_tasks.where(task_id: grouped.task_id, started_at: date.all_day).pluck(:working_time).sum / 60
      end
      # それが終わったら、labelにタスク名を入れる。data（縦軸）にはタスクの種類ごとのworking_timeを計算するための『合計』を入れる（60で割って、分単位にする）
      datasets << {label: grouped.task.content, data: working_times}
    end
  end
end
