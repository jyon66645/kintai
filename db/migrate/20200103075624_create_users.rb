class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, unique: true
      t.string :password_digest
      t.string :remember_digest
      t.boolean :admin, default: false
      t.string :affiliation
      t.datetime :basic_work_time, default: Time.current.change(hour: 8, min: 0, sec: 0)
      t.datetime :work_time, default: Time.current.change(hour: 7, min: 30, sec: 0)
      t.datetime :designated_work_start_time, default: Time.current.change(hour: 9, min: 0, sec: 0)
      t.datetime :designated_work_end_time, default: "2019-12-1 08:00:00 +0000"
      t.integer :employee_number
      t.string :uid
      t.boolean :superior, default: false

      t.timestamps
    end
  end
end
