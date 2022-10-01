module TimesheetEntriesHelper
  def formatted_date(timesheet)
    timesheet.date&.strftime("%d/%m/%Y")
  end

  def time_range(timesheet)
    start_time = timesheet.start_time ? Time.at(timesheet.start_time).utc.strftime("%H:%M") : nil
    finish_time = timesheet.finish_time ? Time.at(timesheet.finish_time).utc.strftime("%H:%M") : nil

    "#{start_time} - #{finish_time}"
  end
end
