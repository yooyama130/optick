class WorkingTask < ApplicationRecord
  belongs_to :user
  belongs_to :task

  # 数値を時間化
  def int_to_time(int)
    hour = 0
    min = 0
    sec = 0
    while int >= 3600 do
      # 1時間 = 3600秒 ---> 3600を引いた回数を時間hourとして出す
      int  -= 3600
      hour += 1
    end
    while int >= 60 do
      # 1分 = 60秒 ---> 60を引いた回数を分minとして出す
      int  -= 60
      min += 1
    end
    # 残った時間を秒secとして出す
    sec = int
    # 最後に文字化
    "#{zero_for_digits(hour)}:#{zero_for_digits(min)}:#{zero_for_digits(sec)}"
  end

  # 1桁を2桁にする（stringとして扱う)
  def zero_for_digits(int)
    if int < 10
      return "0"+ int.to_s
    end
    int.to_s
  end
end
