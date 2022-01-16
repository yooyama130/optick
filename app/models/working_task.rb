class WorkingTask < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :started_at, presence: true, if: :not_being_measured?
  validates :stopped_at, presence: true, if: :not_being_measured?

  # 『記録済みタスクを調べる』機能に使う
  def self.search(container, date_range_start, date_range_end, events, task)
    # 1.最初にstarted_atが検索フォームから送られてきた日付範囲に入っているかを検索
    container = container.where(started_at: date_range_start.beginning_of_day .. date_range_end.end_of_day)
    # # 2.タグ指定があれば、started_atがフォームから送られてきたタグの日付範囲に入っているものだけを取得
    # if events.exists?
    #   events.each do |event|
    #     container = container.or(container.where(started_at: event.start_date.beginning_of_day .. event.end_date.end_of_day))
    #   end
    # end
    # 3.タスク指定があれば、1で取得したものからさらに、フォームから送られてきたタスクのidのものだけ取得
    if task.present?
      container = container.where(task_id: task.id)
    end
    container
  end

  # 「計測中がfalseのとき」の条件式
  def not_being_measured?
    being_measured? == false
  end

  def self.get_date_datas(working_tasks)
    # dates配列を新しく定義
    dates = []
    # インスタンス(self)に保存されているデータの日時を一つずつdates配列に追加していく
    working_tasks.each do |working_task|
      # .to_dateを使って、例えば「11/24/11:00」という情報を「11/24」の日付だけの情報にする。
      dates << working_task.started_at.to_date
    end
    # 重複したものを消す。戻り値として返す
    return dates.uniq
  end
end
