class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy, :log_edit, :show_view_only, :edit_overtime_notice]
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy]
  before_action :current_user_only, only: [:show]
  before_action :logged_in_user_only, only: [:show]
  before_action :correct_user, only: :edit   #updateを追加するとusers/index.html.erbの編集が出来なくなる
  before_action :admin_user, only: [:destroy, :index]
  before_action :set_one_month, only: [:show, :log_edit, :show_view_only]

  
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def import
    # fileはtmpに自動で一時保存される
    User.import(params[:file])
    redirect_to users_url
  end
  
  def show
    
    @worked_sum = @attendances.where.not(started_at: nil).count
    @test = Attendance.where.not(finish_schedule_time: nil)
    @approval = @test.where(approval: "申請中")
    # csv出力
    respond_to do |format|
      format.html
      format.csv do
      users_csv
      end
    end  
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後、ログインします。
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to users_url
    else
      render :edit      
    end
  end
  
  def basic_infomation_edit
    
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}をデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_overtime_notice
    @users = User.all
    @applying_user1 = Attendance.where.not(finish_schedule_time: nil).where(confirmation: "Superior User-1", approval: "申請中").order(:worked_on)
    @user_s = User.where(id: @applying_user1.pluck(:user_id))
    
    @applying_user_plus = Attendance.where.not(finish_schedule_time: nil).where(confirmation: "Superior User-2", approval: "申請中").order(:worked_on)
    @user_plus = User.where(id: @applying_user_plus.pluck(:user_id))
  end
  
  def update_overtime_notice
    
    @user = User.find(params[:id])
     overtime_notice_params.each do |id, item|
      attendance = Attendance.find(id)
      attendance.update_attributes!(item)
      at = Attendance.where('change_checkbox = ? or change_checkbox =  ?', false, nil) 
      at.update(approval: "申請中")
     end
     redirect_to @user
  end
  
  #所属長承認モーダル
  
  def edit_zokucho
    @user = User.find(params[:id])
    #上長1の場合
    users = Attendance.where(zokucho_approval: "申請中", zokucho_confirmation: "上長1")
    @users = User.where(id: users.pluck(:user_id))
    #上長2の場合
     users_plus = Attendance.where(zokucho_approval: "申請中", zokucho_confirmation: "上長2")
    @users_plus = User.where(id: users_plus.pluck(:user_id))
    
    @day = users.pluck(:worked_on)
  end
  
  def update_zokucho
     @user = User.find(params[:id])
     shozokucho_params.each do |id, item|
     attendance = Attendance.find(id)
     attendance.update_attributes(item)
     Attendance.where(zokucho_approval: "承認", zokucho_box: nil).update(zokucho_approval: "申請中")
     Attendance.where(zokucho_approval: "否認", zokucho_box: nil).update(zokucho_approval: "申請中")
     Attendance.where(zokucho_approval: "申請中", zokucho_box: true).update(zokucho_box: nil)
     end
     redirect_to user_url(current_user)
  end
  
  # 申請者の勤怠確認
  def show_view_only
    @user = User.find(params[:id])
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
 # 勤怠変更モーダル
  def edit_attendance_apply
    @user = User.find(params[:id])
    # 上長1の場合
    @at = Attendance.where(approval_attendance: "申請中", confirmation_attendance: "上長1")
    user_id = @at.pluck(:user_id)
    @users = User.where(id: user_id)
    
    # 上長2の場合
    @at_plus = Attendance.where(approval_attendance: "申請中", confirmation_attendance: "上長2")
    user_id = @at_plus.pluck(:user_id)
    @users_plus = User.where(id: user_id)
  end
 
  def update_attendance_apply
   
   @user = User.find(params[:id])
   after_attendances_application_params.each do |id, item|
     attendance = Attendance.find(id)
     attendance.update_attributes(item)
     if attendance.change_checkbox == true

       
       if attendance.approval_attendance == "承認"
       attendance[:log_approval] = Time.current
       attendance[:started_at] = attendance.after_started_at
       attendance[:finished_at] = attendance.after_finished_at
       attendance[:log_after_started_at] = attendance.after_started_at
       attendance[:log_after_finished_at] = attendance.after_finished_at
       attendance[:log_confirmation] = attendance.confirmation_attendance
       attendance.save
       
       # 申請ログの仕様
      # elsif attendance.approval_attendance == "否認"
       # attendance.update_attributes(log_approval: nil) 
      # elsif attendance.approval_attendance == "申請中"
       # attendance.update_attributes[log_approval: nil]
       
       end
      if attendance.log_started_at.nil?
        attendance[:log_started_at] = attendance.after_started_at
        attendance.save
      end
      if attendance.log_finished_at.nil?
        attendance[:log_finished_at] = attendance.after_finished_at
        attendance.save
      end
     end
     at = Attendance.where(change_checkbox: nil).update(approval_attendance: "申請中")
   end
     redirect_to @user
  end
 
  def log_edit
    @log_approval_users = @user.attendances.where.not(log_approval: nil)
  end
  
 
  private
  
  # CSV出力
  def users_csv
  
    csv_date = CSV.generate do |csv|
      csv_column_names = ["日付","出社時間","退社時間"]
      csv << csv_column_names
      @attendances.each do |attendance|
        
          #started_at と finished_at がnilの日を出力。
        if attendance.started_at.blank? && attendance.finished_at.blank?
          csv_column_values = [
          attendance.worked_on,
          attendance.started_at,
          attendance.finished_at
        ]
        csv << csv_column_values
        end
        
        if attendance.started_at.present? || attendance.finished_at.present?
          if attendance.approval_attendance == "承認"
          csv_column_values = [
            attendance.worked_on,
            attendance.started_at.strftime("%H:%M"),
            attendance.finished_at.strftime("%H:%M")
            ]
            csv << csv_column_values
          elsif attendance.approval_attendance == "否認"
          csv_column_values = [
            attendance.worked_on
            ]
            csv << csv_column_values
          elsif attendance.confirmation_attendance == "上長1" && attendance.approval_attendance == "申請中"
          csv_column_values = [
            attendance.worked_on
            ]
            csv << csv_column_values
          else 
            csv_column_values = [
            attendance.worked_on,
            attendance.started_at.strftime("%H:%M"),
            attendance.finished_at.strftime("%H:%M")
            ]
            csv << csv_column_values
          end
          
          
        end
      end
    end
    send_data(csv_date,filename: "users_test.csv")
    
      
  end
  
  
  def user_params
    params.require(:user).permit(:name, :email, :affiliation, :password, :password_confirmation, :employee_number, :uid, :basic_time, :basic_work_time, :designated_work_start_time, :designated_work_end_time, :employee_number)
  end
  # 残業申請用
  def overtime_notice_params
    params.require(:user).permit(attendances: [:approval, :change_checkbox])[:attendances]
  end
  # 勤怠申請用
  def after_attendances_application_params
    params.require(:user).permit(attendances: [:approval_attendance, :change_checkbox])[:attendances]
  end
  # 所属長承認用
  def shozokucho_params
    params.require(:user).permit(attendances: [:zokucho_approval, :zokucho_box])[:attendances]
  end
  
end
