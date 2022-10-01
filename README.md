The setups steps expect following tools installed on the system.

- Github
- Ruby [3.0.0](https://github.com/TienPham110/timesheet-app/blob/fffc0905a85e5b0a2fe159b878f1c515886d4359/.ruby-version#L1)
- Rails [7.0.4](https://github.com/TienPham110/timesheet-app/blob/fffc0905a85e5b0a2fe159b878f1c515886d4359/Gemfile#L7)

# Dev setup
##### 1. Check out the repository

Add your ssh-key to github

```bash
git clone git@github.com:TienPham110/timesheet-app.git
```
##### 2. Create database.yml file

Copy the database.dev.yml file and edit the database configuration as required.

```bash
cp config/database.dev.yml config/database.yml
```

##### 3. Bundle and install taildwind

```ruby
bundle install
rails tailwindcss:install
```

##### 4. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:migrate
```

##### 5. Start the Rails server

You can start the rails server using the command given below.

```bash
./bin/dev
```

And now you can visit the site with the URL http://localhost:3000

# Running Tests

```ruby
RAILS_ENV=test bundle exec rails test
```

# API Endpoints
  GET /timesheet_entries # => get all timesheet entries
  GET /timesheet_entries/new # => get page for new timesheet entry
  POST /timesheet_entries # => create new timesheet entry

# Database structure
  - All timesheet entries are stored in the `timesheet_entries` table (model: TimesheetEntry).
  - With these fields:
    `date` (date) # required
    `start_time` (integer) is store as nth seconds of a day - # required
    `finish_time` (integer) is store as nth seconds of a day - # required
    `caculated_ammount` (float) is calculated from date, start_time and finish_time fields. # See TimesheetEntriesController#caculated_money

# Others
  Some terms are used in this project:

  - Even days: are monday, wednesday, friday
  - Odd days: are tuesday and thursday
  - Weekend: are saturday and sunday
  - Inside: is the time from 5am to 5pm for even days and 7am to 7pm for odd days
  - Outside: is the time outside the inside time
