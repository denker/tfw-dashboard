SECS_IN_DAY = 86400
DAYS_IN_WEEK = 7
SUNDAY_WDAY = 0 # Date.wday returns weekday number from 0 (sunday) to 6 (saturday)
SUNDAY_GOOD_WDAY = 7 # we need wday from 1 (monday) to 7 (sunday), so we change 0 to 7

class DateTime

  def self.new_date(year, month, day)
    DateTime.new(year, month, day, 12, 0, 0, '+3')
  end

  def self.get_work_date
    date_delimeter = DateTime.new_date(Date.today.year, Date.today.month, Date.today.day)
    date_start = DateTime.now >= date_delimeter ? date_delimeter : date_delimeter - 1
  end

  def week_start
    weekday = self.wday != SUNDAY_WDAY ? self.wday : SUNDAY_GOOD_WDAY
    self - weekday + 1
  end

  def week
    self.strftime('%W').to_i + 1  # returns week 1..54 instead of 0..53
  end

  def start_of_prev(interval)
    case interval
    when 'day'
      self - 1
    when 'week'
      self - DAYS_IN_WEEK
    when 'month'
      self << 1
    when 'year'
      self << 12
    end
  end

  def end_of(interval)
    case interval
    when 'day'
      self + 1
    when 'week'
      self + DAYS_IN_WEEK
    when 'month'
      self >> 1
    when 'year'
      self >> 12
    end
  end

  def rewind_to_work_date(interval)
    case interval
    when 'day'
      self
    when 'week'
      self.week_start
    when 'month'
      DateTime.new_date(self.year, self.month, 1)
    when 'year'
      DateTime.new_date(self.year, 1, 1)
    end
  end

  def round_time
    new_minute = (self.minute/5 + (self.minute % 5 > 2 ? 1 : 0) ) * 5
    DateTime.new(self.year, self.month, self.day, self.hour, new_minute, 0, '+3')
  end

end

class String
  def fix
    ['day', 'week', 'month', 'year'].include?(self) ? self : 'day'
  end
end

class Hash
  def make_valid(interval, year, month, day)
    interval = self[:interval].fix
    date = build_work_date(self[:year], self[:month], self[:day])
    date = date.rewind_to_work_date(interval)
    { interval: interval, year: date.year, month: date.month, day: date.day }
  end
end

def build_work_date(year, month, day)
  begin
    DateTime.new_date(year.to_i, month.to_i, day.to_i)
  rescue
    DateTime.get_work_date
  end
end

def stats_link(interval, date = nil)
  case interval.class.to_s
  when 'String'
    "/stats/#{interval}/#{date.year}/#{date.month}/#{date.day}/"
  when 'Hash'
    "/stats/#{interval[:interval]}/#{interval[:year]}/#{interval[:month]}/#{interval[:day]}/"
  else
    "/stats/"
  end
end

def interval_selector_links(date)
  options = {}
  ['year', 'month', 'week', 'day'].each do |int|
    options[int] = stats_link(int, date.rewind_to_work_date(int))
  end
  options
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
