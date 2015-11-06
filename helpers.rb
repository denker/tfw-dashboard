SECS_IN_DAY = 86400
DAYS_IN_WEEK = 7
SUNDAY_WDAY = 0 # Date.wday returns weekday number from 0 (sunday) to 6 (saturday)
SUNDAY_GOOD_WDAY = 7 # we need wday from 1 (monday) to 7 (sunday), so we change 0 to 7

class DateTime
  def week
    # returns week 1..54 instead of 0..53
    self.strftime('%W').to_i + 1
  end
end

def stats_link(interval, date)
  "/stats/#{interval}/#{date.year}/#{date.month}/#{date.day}/"
end

def interval_title(interval, work_date)
  case interval
  when 'day'
    "#{work_date.day}.#{work_date.month}.#{work_date.year}"
  when 'week'
    "Week #{work_date.week} of #{work_date.year}"
  when 'month'
    work_date.strftime("%B, %Y")
  when 'year'
    work_date.year.to_s
  end
end

def interval_end(interval, given_date)
  case interval
  when 'day'
    given_date + 1
  when 'week'
    given_date + DAYS_IN_WEEK
  when 'month'
    given_date >> 1
  when 'year'
    given_date >> 12
  end
end

def prev_interval_start(interval, given_date)
  case interval
  when 'day'
    given_date - 1
  when 'week'
    given_date - DAYS_IN_WEEK
  when 'month'
    given_date << 1
  when 'year'
    given_date << 12
  end
end

def first_week_date(date)
  weekday = date.wday != SUNDAY_WDAY ? date.wday : SUNDAY_GOOD_WDAY
  date - weekday + 1
end

def first_month_date(date)
  DateTime.new(date.year, date.month, 1, 12, 0, 0, '+3')
end

def fix_interval(interval)
  ['day', 'week', 'month', 'year'].include?(interval) ? interval : 'day'
end

def build_work_date(year, month, day)
  begin
    DateTime.new(year.to_i, month.to_i, day.to_i, 12, 0, 0, '+3')
  rescue
    current_work_date
  end
end

def current_work_date
  date_delimeter = DateTime.new(Date.today.year, Date.today.month, Date.today.day, 12, 0, 0, '+3')
  date_start = DateTime.now >= date_delimeter ? date_delimeter : date_delimeter - 1
end

def rewind_to_work_date(interval, date)
  case interval
  when 'day'
    date
  when 'week'
    first_week_date(date)
  when 'month'
    first_month_date(date)
  when 'year'
    DateTime.new(date.year, 1, 1, 12, 0, 0, '+3')
  end
end

def validate_stats_params(interval, year, month, day)
  interval = fix_interval(interval) # TODO maybe refactor as method of String object
  date = build_work_date(year, month, day)
  date = rewind_to_work_date(interval, date) # TODO maybe refactor as method of DateTime
  { interval: interval, year: date.year, month: date.month, day: date.day }
end

def interval_options(date)
  options = {}
  ['year', 'month', 'week', 'day'].each do |int|
    options[int] = stats_link(int, rewind_to_work_date(int, date))
  end
  return options
end
