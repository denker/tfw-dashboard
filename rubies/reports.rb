get '/reports/' do
  # charts are requested in script.js
  slim :reports
end


get '/data.json/' do
  # data for charts
  sd = DateTime.get_work_date - 31
  hash = {
    labels: [],
    datasets: [ {
        fillColor: "rgba(210, 210, 210, 0.2)",
        strokeColor: "rgba(185, 185, 185, 1)",
        pointColor: "rgba(199, 169, 149, 1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "#fff",
        pointHighlightStroke: "rgba(205, 162, 151, 1)",
        data: []
      } ]
    }
  30.times do |i|
    sd += 1
    hash[:labels] << sd.strftime('%d.%m.%Y')
    r = Visit.all(:started_at.gt => sd, :started_at.lt => sd + 1).sum(:revenue)
    hash[:datasets].first[:data] << r.to_i
  end
  json hash
end
