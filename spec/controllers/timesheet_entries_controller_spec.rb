require "rails_helper"

RSpec.describe TimesheetEntriesController, type: :controller do
  describe "#index" do

    context "when request to index endpoint" do
      before do
        TimesheetEntry.create(date: Date.today, start_time: 50000, finish_time: 79200)
      end

      it "responds successfully" do
        get	:index
        expect(response).to	have_http_status "200"
        expect(assigns(:timesheet_entries).pluck(:id)).to eq(TimesheetEntry.all.order(created_at: :desc).pluck(:id))
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "#new" do
    it "renders the :new view" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "#create" do
    context "when params is valid" do
      let(:params) {
        {
          timesheet_entry: {
            date: "Sun, 02 Oct 2022".to_date,
            start_time: "10:00",
            finish_time: "17:00"
          }
        }
      }
      subject {
        post :create, params: params
      }

      it "create a new timesheet entry" do
        expect(TimesheetEntry.count).to eq(0)
        subject
        expect(TimesheetEntry.count).to eq(1)
        expect(TimesheetEntry.last.date).to eq(Date.today)
        expect(TimesheetEntry.last.start_time).to eq(36000)
        expect(TimesheetEntry.last.finish_time).to eq(61200)
        expect(TimesheetEntry.last.caculated_ammount).to eq(329)
      end

      it "renders the :index view" do
        subject
        expect(response).to redirect_to timesheet_entries_url
      end
    end

    context "when params is valid and date is even days" do
      let(:params) {
        {
          timesheet_entry: {
            date: "Fri, 30 Sep 2022".to_date,
            start_time: "10:00",
            finish_time: "20:00"
          }
        }
      }
      subject {
        post :create, params: params
      }

      it "create a new timesheet entry" do
        expect(TimesheetEntry.count).to eq(0)
        subject
        expect(TimesheetEntry.count).to eq(1)
        expect(TimesheetEntry.last.date).to eq("Fri, 30 Sep 2022".to_date)
        expect(TimesheetEntry.last.start_time).to eq(36000)
        expect(TimesheetEntry.last.finish_time).to eq(72000)
        expect(TimesheetEntry.last.caculated_ammount).to eq(231)
      end

      it "renders the :index view" do
        subject
        expect(response).to redirect_to timesheet_entries_url
      end
    end

    context "when params is valid and date is odd days" do
      let(:params) {
        {
          timesheet_entry: {
            date: "Thu, 29 Sep 2022".to_date,
            start_time: "10:00",
            finish_time: "20:00"
          }
        }
      }
      subject {
        post :create, params: params
      }

      it "create a new timesheet entry" do
        expect(TimesheetEntry.count).to eq(0)
        subject
        expect(TimesheetEntry.count).to eq(1)
        expect(TimesheetEntry.last.date).to eq("Thu, 29 Sep 2022".to_date)
        expect(TimesheetEntry.last.start_time).to eq(36000)
        expect(TimesheetEntry.last.finish_time).to eq(72000)
        expect(TimesheetEntry.last.caculated_ammount).to eq(280)
      end

      it "renders the :index view" do
        subject
        expect(response).to redirect_to timesheet_entries_url
      end
    end

    context "when params is invalid" do
      let(:params) {
        {
          timesheet_entry: {
            date: Date.today,
            start_time: "10:00",
            finish_time: "9:00"
          }
        }
      }

      subject {
        post :create, params: params
      }

      it "doesn't create a new timesheet entry" do
        expect(TimesheetEntry.count).to eq(0)
        subject
        expect(TimesheetEntry.count).to eq(0)
      end

      it "renders the :new view" do
        subject
        expect(response).to render_template :new
      end
    end
  end
end