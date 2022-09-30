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
    starts_at_secs = timesheet_entry_params[:starts_at].present? ? (timesheet_entry_params[:starts_at].to_time - Date.today.to_time).to_i : nil
    ends_at_secs = timesheet_entry_params[:ends_at].present? ? (timesheet_entry_params[:ends_at].to_time - Date.today.to_time).to_i : nil

    @timesheet_entry = TimesheetEntry.new(
      timesheet_entry_params.merge(
        starts_at: starts_at_secs,
        ends_at: ends_at_secs
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
      params.fetch(:timesheet_entry, {}).permit(:date, :starts_at, :ends_at)
    end
end
