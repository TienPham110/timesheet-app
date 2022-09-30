module TimesheetEntriesHelper
  def formatted_date(timesheet)
    timesheet.date.strftime("%d/%m/%Y")
  end
  
  def time_range(timesheet)
    "#{Time.at(timesheet.start_time).utc.strftime("%H:%M")} - #{Time.at(timesheet.finish_time).utc.strftime("%H:%M")}"
  end
end
