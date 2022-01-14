class WorkingTask < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :started_at, presence: true, if: :not_being_measured?
  validates :stopped_at, presence: true, if: :not_being_measured?

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
