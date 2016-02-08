require 'date'

SECS_IN_DAY = 86400
DAYS_IN_WEEK = 7
SUNDAY_WDAY = 0 # Date.wday returns weekday number from 0 (sunday) to 6 (saturday)
SUNDAY_GOOD_WDAY = 7 # we need wday from 1 (monday) to 7 (sunday), so we change 0 to 7

def hour_select_array(hour, end_time = false)
  # makes list for time selector in Visits view
  hour = DateTime.now.hour if hour == -1
  array = ((hour-4)..(hour+1)).to_a
  hour >= 12 ? array.delete_if { |a| a < 12 } : array.delete_if { |a| a >= 12 }
  array.map! { |h| h < 0 ? h + 24 : h }
  end_time ? [-1] + array : array
end

def minutes_select_array(end_time = false)
  arr = []
  arr << -1 if end_time
  12.times { |i| arr << i * 5 }
  arr
end

class NilClass
  def hour
    -1
  end
  def minute
    -1
  end
end

# TODO refactor mixins to DateTime and Hash as new classes-wrappers. DateTime -> WorkDate

class DateTime

  def self.new_date(year, month, day)
    DateTime.new(year, month, day, 12, 0, 0, '+3')
  end

  def self.set_time(hour, minute)
    if hour == -1 || minute== -1
      date = nil
    else
      date = DateTime.new(Date.today.year, Date.today.month, Date.today.day, hour, minute, 0, '+3')
      date += 1 if DateTime.now.hour >= 12 && hour < 12
      date -= 1 if DateTime.now.hour < 12 && hour >= 12
    end
    date
  end

  def self.get_work_date(date = Date.today)
    # get work date from scratch
    delimeter = DateTime.new_date(date.year, date.month, date.day)
    DateTime.now >= delimeter ? delimeter : delimeter - 1
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
    hour = self.hour
    minute = ( self.minute / 5  + (self.minute % 5 > 2 ? 1 : 0 ) ) * 5
    if minute < 60
      new_date = DateTime.new(self.year, self.month, self.day, hour, minute, 0, '+3')
    else
      minute = 0
      hour = 0 if ( hour += 1 ) > 23
      new_date = DateTime.new(self.year, self.month, self.day, hour, minute, 0, '+3')
      self.hour == 23 && hour == 0 ? new_date += 1 : new_date
    end
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

def visit_hash( vp, new, save = nil )
  vp.each { |k,v| vp[k] = v.to_i unless k == 'comment' || k == 'age' }
  if new    
    vp[:started_at] = DateTime.now.round_time
  else
    vp[:started_at] = DateTime.set_time(vp[:start_hour], vp[:start_minute])
    vp[:finished_at] = save ? DateTime.set_time(vp[:end_hour], vp[:end_minute]) : DateTime.now.round_time
    ["start_hour", "start_minute", "end_hour", "end_minute"].each { |k| vp.delete k }
    ["if_snacks", "if_hot_meal", "if_first_visit"].each { |k| vp[k] = vp.has_key?(k) }
  end
  vp
end


# HISTORY

def parse_single_date(date)
  date_source = date.split('.')
  build_work_date(date_source[2], date_source[1], date_source[0])
end

def parse_dates(array)
  [ parse_single_date(array.first),
    parse_single_date(array.last) ]
end

def group_by_date(visits, first_date, last_date)
  result = []
  while first_date < last_date
    result << [ first_date, visits.all(:started_at.gt => first_date, :started_at.lt => first_date + 1, :order => [ :started_at.asc ])]
    first_date += 1
  end
  result
end
