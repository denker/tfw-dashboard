get '/reports/' do
  # charts are requested in script.js
  redirect to "/reports/day/"
end

get '/reports/:range/' do
  redirect to "/reports/day/" unless params[:range].fix == params[:range]
  @range = params[:range].fix # could be used for AJAX chart load
  slim :reports
end


get '/data.json/:range' do
  # data for charts
  hash = {
    labels: [],
    datasets: [
      {
        fillColor: "rgba(235, 182, 127, 0.53)",
        strokeColor: "rgba(185, 185, 185, 1)",
        pointColor: "rgba(199, 169, 149, 1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(205, 162, 151, 1)",
        data: []
      }
    ]
  }
  rng = params[:range].fix
  finish = DateTime.get_work_date.rewind_to_work_date(rng)
  labels = []
  data   = []

  30.times do |i|
    start = finish.start_of_prev(rng)
    labels << start.strftime('%d.%m.%Y') # TODO special labels for weeks, months and years
    data << Visit.all(:started_at.gt => start, :started_at.lte => finish).sum(:revenue).to_i
    finish = start.start_of_prev(rng)
  end

  hash[:labels] = labels.reverse
  hash[:datasets].first[:data] = data.reverse
  json hash

end
