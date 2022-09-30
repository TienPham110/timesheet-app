class TimesheetEntry < ApplicationRecord
  validates :date, :start_time, :finish_time, presence: { message: "is required" }
  validates :date, comparison: { less_than_or_equal_to: Date.today, message: "can't be in the future" }
  validates :finish_time, comparison: { greater_than: :start_time, message: "can't be before start time" }
end
