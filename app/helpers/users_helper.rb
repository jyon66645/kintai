module UsersHelper
  
  # 勤怠基本情報を指定のフォーマットで返します
  def format_basic_info(time)
    format("%.2f", ((time.hour * 60) + time.min) / 60.0)
  end
  
  def format_basic_info_plus(time)
    format("%.2f", (((time.hour * 60) + time.min) / 60.0) + 24.0)
  end
  
  #ログイン中のユーザーidが２or3かを確かめる　superiorユーザーのみ
  def superior_user
    current_user.id == (2 || 3)
  end
  
  #finish_schedule_timeの値を持っている && "Superior User-1"へ申請中のユーザーの数を表示
  def approval_count
    @test = Attendance.where.not(finish_schedule_time: nil).where(confirmation: "Superior User-1", approval: "申請中")
    @approval_count = @test.count 
  end
  #finish_schedule_timeの値を持っている && "Superior User-2"へ申請中のユーザーの数を表示
  def approval_count_plus
    @test = Attendance.where.not(finish_schedule_time: nil).where(confirmation: "Superior User-2", approval: "申請中")
    @approval_count = @test.count 
  end
  
  #上長1への勤怠申請の数
  def after_approbal_count
    @at = Attendance.where.not(after_started_at: nil, after_started_at: nil).where(confirmation_attendance: "上長1", approval_attendance: "申請中")
    @at.count
  end
  
  def after_approbal_count_plus
    @at = Attendance.where.not(after_started_at: nil, after_started_at: nil).where(confirmation_attendance: "上長2", approval_attendance: "申請中")
    @at.count
  end
  
  def approval_count_attendance
    @test = Attendance.where.not(finish_schedule_time: nil).where(confirmation_attendance: "上長1", approval_attendance: "申請中")
    @approval_count_attendance = @test.count
  end
  
  # Superior User-1へ申請中のユーザー全てを表示
  def applying_user_superior1
     @applying_user1 = Attendance.where.not(finish_schedule_time: nil).where(confirmation: "Superior User-1", approval: "申請中")
  end
  
  # Superior User-2へ申請中のユーザー全てを表示
  def applying_user_superior2
     @applying_user2 = Attendance.where.not(finish_schedule_time: nil).where(confirmation: "Superior User-2", approval: "申請中")
  end
  
  # Superior User-1へ申請中のユーザーの名前を全て表示
  def applying_user_name
    @applying_user1 = Attendance.where.not(finish_schedule_time: nil).where(confirmation: "Superior User-1", approval: "申請中")
    @user = User.where(id: @applying_user1.pluck(:user_id))
  end
  
  def shozokucho_approval_count
    @user = Attendance.where(zokucho_approval: "申請中", zokucho_confirmation: "上長1").count
  end
  
  def shozokucho_approval_count_plus
    @user = Attendance.where(zokucho_approval: "申請中", zokucho_confirmation: "上長2").count
  end
  
end
