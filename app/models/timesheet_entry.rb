class TimesheetEntry < ApplicationRecord
  validates :date, :starts_at, :ends_at, presence: true
end
