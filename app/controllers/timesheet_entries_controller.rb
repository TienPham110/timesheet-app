class TimesheetEntriesController < ApplicationController
  before_action :set_timesheet_entry, only: %i[ show edit update destroy ]

  # GET /timesheet_entries or /timesheet_entries.json
  def index
    @timesheet_entries = TimesheetEntry
      .all
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
    starts_at = timesheet_entry_params[:start_time].present? ? (timesheet_entry_params[:start_time].to_time - Date.today.to_time).to_i : nil
    ends_at = timesheet_entry_params[:finish_time].present? ? (timesheet_entry_params[:finish_time].to_time - Date.today.to_time).to_i : nil

    @timesheet_entry = TimesheetEntry.new(
      timesheet_entry_params.merge(
        start_time: starts_at,
        finish_time: ends_at
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
end
