# contorollers for Visit model and /visits/ views
# works as part of app.rb

get '/visits/' do
  @visits = Visit.all(:started_at.gt => DateTime.get_work_date)
  slim :'visits'
end

get '/visits/:id/' do
  @visits = Visit.all(:started_at.gt => DateTime.get_work_date)
  @edit_id = params[:id].to_i
  @finished_at = @visits.get(@edit_id).finished_at
  slim :'visits'
end

delete '/visits/:id/' do
  Visit.get(params[:id]).destroy!
  redirect to('/visits/')
end

post '/visits/' do
  visit_params = params[:visit]
  Visit.create visit_hash( visit_params, true )
  redirect to('/visits/')
end

put '/visits/:id/' do
  vp = params[:visit]
  visit = Visit.get params[:id]
  visit.update visit_hash( vp, false, params[:action] == 'save' )
  redirect to('/visits/')
end

patch '/visits/:id/' do
  visit = Visit.get(params[:id])
  visit.finished_at = DateTime.now.round_time
  visit.save
  redirect to('/visits/')
end
