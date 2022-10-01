FactoryBot.define do
  factory :timesheet_entry do |f|
    f.date { Date.today }
    f.start_time { 43200 }
    f.finish_time { 79200 }
  end
end