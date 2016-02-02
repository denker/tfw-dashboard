# contorollers for Visit model and /visits/ views
# works as part of app.rb

get '/visits/' do
  @visits = Visit.all(:time_start.gt => DateTime.get_work_date)
  slim :'visits'
end

get '/visits/:id/' do
  @visits = Visit.all(:time_start.gt => DateTime.get_work_date)
  @edit_id = params[:id].to_i
  @time_end = @visits.get(@edit_id).time_end
  slim :'visits'
end

delete '/visits/:id/' do
  visit = Visit.get params[:id]
  visit.destroy!
  redirect to('/visits/')
end

post '/visits/new/' do
  vp = params[:visit] # TODO refactor visit params hash to automagically update all fields in Visit
  vp.each { |k,v| vp[k] = v.to_i unless k == 'comment' }
  visit = Visit.new
  visit.time_created = DateTime.now
  visit.time_start = DateTime.now.round_time
  visit.male = vp[:male]
  visit.female = vp[:female]
  visit.comment = vp[:comment]
  visit.save
  redirect to('/visits/')
end

put '/visits/:id/' do
  vp = params[:visit]
  vp.each { |k,v| vp[k] = v.to_i unless k == 'comment' || k == 'age' }
  visit = Visit.get(params[:id])
  visit.time_start = DateTime.set_time(vp[:start_hour], vp[:start_minute])
  if params[:action] == "save"
    visit.time_end = DateTime.set_time(vp[:end_hour], vp[:end_minute]) # TODO add validation for time_end > time_start
  else
    visit.time_end = DateTime.now.round_time
  end
  visit.revenue = vp[:revenue]
  visit.bycard = vp[:bycard]
  visit.tips = vp[:tips]
  visit.male = vp[:male]
  visit.female = vp[:female]
  visit.age = vp[:age]
  visit.if_snacks = vp.has_key? "if_snacks"
  visit.if_hot_meal = vp.has_key? "if_hot_meal"
  visit.if_first_visit = vp.has_key? "if_first_visit"
  visit.comment = vp[:comment]
  redirect to('/visits/')
end

patch '/visits/:id/' do
  visit = Visit.get(params[:id])
  visit.time_end = DateTime.now.round_time
  visit.save
  redirect to('/visits/')
end
