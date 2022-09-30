require "test_helper"

class TimesheetEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @timesheet_entry = timesheet_entries(:one)
  end

  test "should get index" do
    get timesheet_entries_url
    assert_response :success
  end

  test "should get new" do
    get new_timesheet_entry_url
    assert_response :success
  end

  test "should create timesheet_entry" do
    assert_difference("TimesheetEntry.count") do
      post timesheet_entries_url, params: { timesheet_entry: {  } }
    end

    assert_redirected_to timesheet_entry_url(TimesheetEntry.last)
  end
end
