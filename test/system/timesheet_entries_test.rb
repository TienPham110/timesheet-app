require "application_system_test_case"

class TimesheetEntriesTest < ApplicationSystemTestCase
  setup do
    @timesheet_entry = timesheet_entries(:one)
  end

  test "visiting the index" do
    visit timesheet_entries_url
    assert_selector "h1", text: "Timesheet entries"
  end

  test "should create timesheet entry" do
    visit timesheet_entries_url
    click_on "New timesheet entry"

    click_on "Create Timesheet entry"

    assert_text "Timesheet entry was successfully created"
    click_on "Back"
  end
end
