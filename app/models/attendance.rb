class Attendance < ApplicationRecord
  belongs_to :user
  
  validate :started_at_than_finished_at_fast_if_invalid
  
  validates :worked_on, presence: :true
  validates :note, length: { maximum: 50 }
  
 
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  
   # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  
  validate :finish_schedule_time_validate 
  validate :after_finished_at_nesessary
  validate :finished_at_is_invalid_without_a_started_at
  validate :confirmation_attendance_validate
  validate :confirmation_attendance_validate_plus

  def finish_schedule_time_validate
    if finish_schedule_time.present? && user.designated_work_end_time.present? && !tomorrow?
      errors.add(:finish_work_time, "より早い終了予定時間は無効です") if finish_schedule_time.to_i < user.designated_work_end_time.to_i
    end
  end
  
  def after_finished_at_nesessary
    if after_started_at.present? && after_finished_at.blank?
      errors.add(:after_finished_at, "が必要です") 
    end
  end
  
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:after_started_at, "が必要です") if after_started_at.blank? && after_finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if after_started_at.present? && after_finished_at.present?
      errors.add(:after_started_at, "より早い退勤時間は無効です") if after_started_at > after_finished_at
    end
  end
  
  def confirmation_attendance_validate
   if after_started_at.blank? && after_finished_at.blank?
     if confirmation_attendance.present?
     errors.add(:confirmation_attendance, "が必要です")
     end
   end
  end
  
  def confirmation_attendance_validate_plus
   if after_started_at.present? && after_finished_at.present?
     if confirmation_attendance == ""
     errors.add(:confirmation_attendance, "が必要です")
     end
   end
  end
  
end