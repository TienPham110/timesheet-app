class TimesheetEntry < ApplicationRecord
  validates :date, :start_time, :finish_time, presence: { message: "is required" }
  validates :date, comparison: { less_than_or_equal_to: Date.today, message: "can't be in the future" },
    :if => Proc.new { |o| o.errors[:date].blank? }
  validates :finish_time, comparison: { greater_than_or_equal_to: :start_time, message: "can't be before start time" },
    :if => Proc.new { |o| o.errors[:start_time].blank? && o.errors[:finish_time].blank? }
  validate :cannot_overllap_timesheet

  scope :by_overlapping, -> range {
    where(start_time: range).or(where(finish_time: range))
      .or(where("start_time <= ? AND finish_time >= ? ", range.begin, range.end))
  }
  scope :by_date, -> date { where(date: date) }

  RATE = { # In dollar $
    INSIDE_EVEN_DAY: 22, # Even days are monday, wednesday, friday
    OUTSIDE_EVEN_DAY: 33,
    INSIDE_ODD_DAY: 25, # Odd days are tuesday and thursday
    OUTSIDE_ODD_DAY: 35,
    WEEKEND: 47
  }

  INSIDE_SECONDS_RANGE = {
    EVEN_DAY: 25200..68400, # 7am - 7pm
    ODD_DAY: 18000..61200 # 5am - 5pm
  }

  private
    def cannot_overllap_timesheet
      return unless date && start_time && finish_time

      overlaps = TimesheetEntry
        .by_date(date)
        .by_overlapping(start_time..finish_time)

        errors.add(:base, "Can't have overlapping timesheet entries") unless overlaps.empty?
    end
end
