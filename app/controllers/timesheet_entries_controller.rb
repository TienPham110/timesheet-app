class TimesheetEntriesController < ApplicationController
  before_action :set_timesheet_entry, only: %i[ show edit update destroy ]

  SECONDS_IN_AN_HOUR = 3600

  # GET /timesheet_entries or /timesheet_entries.json
  def index
    @timesheet_entries = TimesheetEntry
      .all
      .order(created_at: :desc)
      .paginate(
        page: params[:page],
        per_page: DEFAULT_PAGE_SIZE
      )
  end

  # GET /timesheet_entries/new
  def new
    @timesheet_entry = TimesheetEntry.new
  end

  # POST /timesheet_entries or /timesheet_entries.json
  def create
    starts_at = timesheet_entry_params[:start_time].present? ?
      (timesheet_entry_params[:start_time].to_time - Date.today.to_time).to_i
      : nil
    ends_at = timesheet_entry_params[:finish_time].present? ?
      (timesheet_entry_params[:finish_time].to_time - Date.today.to_time).to_i
      : nil

    @timesheet_entry = TimesheetEntry.new(
      timesheet_entry_params.merge(
        start_time: starts_at,
        finish_time: ends_at,
        caculated_ammount: caculated_money(timesheet_entry_params[:date].to_date, starts_at, ends_at)
      )
    )

    if @timesheet_entry.save
      redirect_to timesheet_entries_url, notice: "Timesheet entry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_timesheet_entry
      @timesheet_entry = TimesheetEntry.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def timesheet_entry_params
      params.fetch(:timesheet_entry, {}).permit(:date, :start_time, :finish_time)
    end

    def caculated_money(date, start_time, finish_time)
      if date.blank? || start_time.blank? || finish_time.blank? || start_time == finish_time
        return 0
      end

      range = [finish_time - start_time, 0].max

      case date.wday
      when 1, 3, 5 # monday, wednesday, friday
        outside_secs = [TimesheetEntry::INSIDE_SECONDS_RANGE[:EVEN_DAY].begin - start_time, 0].max +
          [finish_time - TimesheetEntry::INSIDE_SECONDS_RANGE[:EVEN_DAY].end, 0].max

        inside_secs = [range - outside_secs, 0].max

        secs_to_hours(outside_secs)*TimesheetEntry::RATE[:OUTSIDE_EVEN_DAY] +
        secs_to_hours(inside_secs)*TimesheetEntry::RATE[:INSIDE_EVEN_DAY]
      when 2, 4 # tuesday, thursday
        outside_secs = [TimesheetEntry::INSIDE_SECONDS_RANGE[:ODD_DAY].begin - start_time, 0].max +
          [finish_time - TimesheetEntry::INSIDE_SECONDS_RANGE[:ODD_DAY].end, 0].max

        inside_secs = [range - outside_secs, 0].max

        secs_to_hours(outside_secs)*TimesheetEntry::RATE[:OUTSIDE_ODD_DAY] +
        secs_to_hours(inside_secs)*TimesheetEntry::RATE[:INSIDE_ODD_DAY]
      when 0, 6 # weekend
        hours = secs_to_hours(range)

        hours*TimesheetEntry::RATE[:WEEKEND]
      end
    end

    def secs_to_hours(secs)
      (secs.to_f / SECONDS_IN_AN_HOUR).round(2)
    end
end
