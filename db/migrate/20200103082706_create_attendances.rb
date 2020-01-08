class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.integer :user_id
      t.datetime :finish_schedule_time
      t.text :business_process
      t.boolean :tomorrow
      t.string :confirmation
      t.string :approval, default: "申請中"
      t.boolean :change_checkbox
      t.string :approval_attendance
      t.string :confirmation_attendance
      t.datetime :after_started_at
      t.datetime :after_finished_at
      t.string :after_note
      t.string :zokucho_approval
      t.string :zokucho_confirmation
      t.date :zokucho_day
      t.boolean :zokucho_box
      t.datetime :log_started_at
      t.datetime :log_finished_at
      t.string :log_approval
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
