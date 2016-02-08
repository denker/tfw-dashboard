require 'ap'

get '/history/*/to/*/' do
  @dates = params[:splat].join(' - ')
  dates = parse_dates(params[:splat])
  visits = Visit.all(:time_start.gt => dates.first, :time_start.lte => dates.last + 1)
  @visits = group_by_date(visits, dates.first, dates.last + 1)
  @totals = {
    male: visits.sum(:male),
    female: visits.sum(:female),
    revenue: visits.sum(:revenue),
    tips: visits.sum(:tips),
    bycard: visits.sum(:bycard)
  }
  slim :history
end

get '/history/' do
  date = DateTime.get_work_date
  redirect to("/history/#{ (date-1).strftime('%d.%m.%Y') }/to/#{ date.strftime('%d.%m.%Y') }")
end

get '/history/*/' do
  date_two = DateTime.get_work_date
  redirect to("/history/#{params[:splat].first}/to/#{ date_two.strftime('%d.%m.%Y') }")
end
