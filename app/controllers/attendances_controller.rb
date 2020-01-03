class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :working_users]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_user, only: [:working_users]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: [:edit_one_month, :working_users, :edit_zokucho]
  
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
     # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        @attendance.update_attributes(log_started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        @attendance.update_attributes(log_finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def working_users
    @users = User.all
    @attendances.find_by(worked_on: Date.current)
  end
  
  # 勤怠編集画面
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始します。
      after_attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
        attendance.update_attributes(approval_attendance: "申請中")
      end
    end
     flash[:success] = "1ヶ月分の勤怠情報を申請しました。"
     redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
     flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
     redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  
    # 残業申請

  def edit_overtime
    @attendance = Attendance.find(params[:id])
    @user = User.find(params[:user_id])
    @superior = User.where(id: [2, 3])
    @day = Date.parse(params[:day])
    @wday = (params[:wday])
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
  end
  
  def update_overtime
     @user = current_user
     @attendance = Attendance.find(params[:id])
     if @attendance.update_attributes(overtime_params)
       @attendance.update_attributes(approval: "申請中")
       @attendance.update_attributes(change_checkbox: "false")
       flash[:success] = "申請しました。"
       redirect_to @user
     else
       flash[:danger] = "無効なデータがありました。"
       redirect_to @user
     end
  end

  
  def update_zokucho_approval #所属長承認申請用
   @user = User.find(params[:id])
   @user.attendances.update(shozokucho_params)
     if @user.attendances.find_by(worked_on: params[:date]).zokucho_confirmation == "上長1" || @user.attendances.find_by(worked_on: params[:date]).zokucho_confirmation == "上長2"
      @user.attendances.where(worked_on: params[:date]).update(zokucho_approval: "申請中")
      @user.attendances.where(worked_on: params[:date]).update(zokucho_day: params[:date])
       flash[:success] = "1ヶ月分の勤怠情報を申請しました。"
       redirect_to @user
     else
      flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
      redirect_to user_url(date: params[:date])
     end
  end

  private
  
  # 1ヶ月分の勤怠情報を扱います。
  def attendances_params
    params.require(:user).permit(attendances: [:started_at, :finished_at, :note, :log_started_at, :log_finished_at])[:attendances]
  end
  
  def overtime_params
    params.require(:attendance).permit(:finish_schedule_time, :business_process, :tomorrow, :confirmation)
  end
  
  def after_attendances_params
    params.require(:user).permit(attendances: [:after_started_at, :after_finished_at, :after_note, :tomorrow, :confirmation_attendance, :approval_attendance])[:attendances]
  end
  
   # 所属長承認用
  def shozokucho_params
    params.require(:user).permit(attendances: [:zokucho_confirmation])[:attendances]
  end
  
  # beforeフィルター

  # 管理権限者、または現在ログインしているユーザーを許可します。
  def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
    unless current_user?(@user) || current_user.admin?
      flash[:danger] = "編集権限がありません。"
      redirect_to(root_url)
    end  
  end
end