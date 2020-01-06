class AddLogConfirmationToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :log_confirmation, :string
  end
end
