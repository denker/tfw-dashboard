def get_date_start
  today = Date.today
  date_delimeter = Time.new(today.year, today.month, today.day, 12, 0)
  date_start = Time.now >= date_delimeter ? date_delimeter : date_delimeter - 86400
end

def period_nav_link(period_type, date, to_add)
  case period_type
  when 'day'
    "/stats/#{period_type}/#{year}/#{month}/#{(date+86400*to_add).day}"
  when 'week'
    # smth
  when 'month'
    # smth
  when 'year'
    # smth
  else
    # smth
  end
end

def prev_link(type, date)
end

def next_link(type, date)

end
