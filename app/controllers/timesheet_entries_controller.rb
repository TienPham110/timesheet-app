class TimesheetEntriesController < ApplicationController
  before_action :set_timesheet_entry, only: %i[ show edit update destroy ]

  # GET /timesheet_entries or /timesheet_entries.json
  def index
    @timesheet_entries = TimesheetEntry.all
  end

  # GET /timesheet_entries/new
  def new
    @timesheet_entry = TimesheetEntry.new
  end

  # POST /timesheet_entries or /timesheet_entries.json
  def create
    @timesheet_entry = TimesheetEntry.new(timesheet_entry_params)

    respond_to do |format|
      if @timesheet_entry.save
        format.html { redirect_to timesheet_entries_url, notice: "Timesheet entry was successfully created." }
        format.json { render :show, status: :created, location: @timesheet_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @timesheet_entry.errors, status: :unprocessable_entity }
      end
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
