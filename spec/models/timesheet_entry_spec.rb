require "rails_helper"

RSpec.describe TimesheetEntry, type: :model do
  subject { described_class.new }

  context "is invalid without date, start_time and finish_time" do
    it "should be invalid" do
      expect(subject).to_not be_valid
    end
  end


  context "is valid with date, start_time and finish_time" do
    it "should be valid" do
      subject.date = Date.today
      subject.start_time = 43200
      subject.finish_time = 79200

      expect(subject).to be_valid
    end
  end

  context "is invalid with future date" do
    it "should be invalid" do
      subject.date = Date.today + 1.day
      subject.start_time = 43200
      subject.finish_time = 79200

      expect(subject).to_not be_valid
    end
  end

  context "is invalid with finish_time before start_time" do
    it "shoule be invalid" do
      subject.date = Date.today
      subject.start_time = 79200
      subject.finish_time = 43200

      expect(subject).to_not be_valid
    end
  end

  context "is invalid if there is a overlapping timesheet entry" do
    before do
      described_class.create(date: Date.today, start_time: 50000, finish_time: 79200)
    end

    it "should be invalid" do
      subject.date = Date.today
      subject.start_time = 43200
      subject.finish_time = 79200

      expect(subject).to_not be_valid
    end
  end
end