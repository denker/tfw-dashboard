# contorollers for Visit model and /visits/ views
# works as part of app.rb

get '/visits/' do
  @visits = Visit.all
  slim :visits
end

get '/visits/:id/' do
  @visits = Visit.all
  @edit_id = params[:id].to_i
  slim :visits
end

delete '/visits/:id/' do
  visit = Visit.get params[:id]
  visit.destroy!
  redirect to('/visits/')
end

post '/visits/new/' do
  params[:visit].each { |k,v| params[:visit][k] = v.to_i }
  visit = Visit.new params[:visit]
  visit.time_start = DateTime.now
  visit.save
  redirect to('/visits/')
end

put '/visits/:id/' do
  visit = Visit.get(params[:id])
  visit.time_end = DateTime.now
  visit.attributes = params[:visit]
  visit.save
  redirect to('/visits/')
end
