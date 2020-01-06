class AddLoginfoToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :log_after_started_at, :datetime
    add_column :attendances, :log_after_finished_at, :datetime
  end
end
