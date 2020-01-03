module AttendancesHelper
  
  
  # 出勤時間と退勤時間を受け取り、在社時間を計算して返します。
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60) / 60.0))
  end
  
  def name_change(superior_name)
    if superior_name == "Superior User-2"
      superior_name = "上長2"
    elsif
      superior_name == "Superior User-1"
      superior_name = "上長1"
    end
  end
  
end
