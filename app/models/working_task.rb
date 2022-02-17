class WorkingTask < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :started_at, presence: true, if: :not_being_measured?
  validates :stopped_at, presence: true, if: :not_being_measured?

  # 「計測中がfalseのとき」の条件式（上のバリデーションで使う）
  def not_being_measured?
    being_measured? == false
  end

  def stop_measuring
    # 現在時刻を取得し、終了時間（started_at）に代入し、being_measured?（計測中？）をfalseにする
    now = Time.current
    self.update(stopped_at: now, being_measured?: false)
    # 経過時間を終了時間 - 開始時間 で　出す
    working_time = self.stopped_at - self.started_at
    self.update(working_time: working_time)
  end

  # ------------------------workingtimeを数値化するのに使用（ここから）-------------------------------
  # 1桁を2桁にする（stringとして扱う)
  def zero_for_digits(int)
    if int < 10
      return "0" + int.to_s
    end
    int.to_s
  end

  # 数値（working_time）を時間化
  def int_to_time(int)
    hour = 0
    min = 0
    sec = 0
    while int >= 3600
      # 1時間 = 3600秒 ---> 3600を引いた回数を時間hourとして出す
      int  -= 3600
      hour += 1
    end
    while int >= 60
      # 1分 = 60秒 ---> 60を引いた回数を分minとして出す
      int  -= 60
      min += 1
    end
    # 残った時間を秒secとして出す
    sec = int
    # 最後に文字化
    "#{zero_for_digits(hour)}:#{zero_for_digits(min)}:#{zero_for_digits(sec)}"
  end
  # ------------------------workingtimeを数値化するのに使用（ここまで）-------------------------------

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
    date_array.uniq
  end

  # ----------------------------------------グラフデータ送信用-------------------------------------------------------------------------------------------
  # 棒グラフ（合計値）
  def self.data_for_bar_graph_SUM(working_tasks, labels, data)
    # タスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    working_tasks_grouped = working_tasks.group(:task_id)
    working_tasks_grouped.each do |grouped|
      # タスクの種類だけ処理を繰り返す。
      # labels（横軸）は、タスクの名前。data（縦軸）にはタスクの種類ごとのworking_timeを計算するための『合計』を入れる。（60で割って、分単位にする。秒も見たいので小数化）
      labels << grouped.task.content
      data << (working_tasks.where(task_id: grouped.task_id).sum(:working_time) / 60.to_f).round(2)
    end
  end

  # 棒グラフ（平均値）
  def self.data_for_bar_graph_AVG(working_tasks, labels, data)
    # タスクを、task_idごとに、データをまとめる(3種類あれば3つにする、5種類あれば5つにする)
    working_tasks_grouped = working_tasks.group(:task_id)
    working_tasks_grouped.each do |grouped|
      # タスクの種類だけ処理を繰り返す。
      # labels（横軸）は、タスクの名前。
      # data（縦軸）にはタスクの種類ごとのworking_timeを計算するための『平均』を入れる。（60で割って、分単位にする。秒も見たいので小数化）
      labels << grouped.task.content
      data << (working_tasks.where(task_id: grouped.task_id).average(:working_time) / 60.to_f).round(2)
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
      data << working_tasks.where(task_id: grouped.task_id).sum(:working_time)
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
        # 日付がある分だけ、「その日のタスクの実働時間の合計」を取り出して、配列に入れていく（60で割って、分単位にする。秒も見たいので小数化）
        working_times << (working_tasks.where(task_id: grouped.task_id, started_at: date.all_day).sum(:working_time) / 60.to_f).round(2)
      end
      # それが終わったら、labelにタスク名を入れる。data（縦軸）にはタスクの種類ごとのworking_timeを計算するための『合計』を入れる
      datasets << { label: grouped.task.content, data: working_times }
    end
  end
end
