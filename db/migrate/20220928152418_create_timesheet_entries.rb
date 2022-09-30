class CreateTimesheetEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :timesheet_entries do |t|
      t.date :date
      t.datetime :starts_at
      t.datetime :ends_at
      t.float :caculated_ammount, deafult: 0.0

      t.timestamps
    end
  end
end
