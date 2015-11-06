# service script for populating DB with CSV data

require './rubies/models'

DataMapper.auto_migrate!

def full_date_parse(string)
  data = string.split(' ')
  dt_src = data[0].split('/')
  date = Time.new( dt_src[2].to_i, dt_src[0].to_i, dt_src[1].to_i )
  Time.parse(data[1], date)
end

f = File.new("#{Dir.pwd}/broken_lines.txt", "w")

arr = []
File.readlines("#{Dir.pwd}/tfw-guests.csv").each do |line|
  data = line.split(',')
  #Visit.create(
  a = {
    :time_start => full_date_parse(data[-2]),
    :time_end => full_date_parse(data[-1]),
    :male => data[3].to_i,
    :female => data[4].to_i,
    :revenue => data[5].to_i,
    :tips => data[6].to_i,
    :comment => data[7,data.count-11].join(', ')#.sub("\"", "")
  }
  v = Visit.create a
  unless v.saved?
    v.comment = 'DELETED'
    v.save
  end
  unless v.saved?
    puts a
    f.puts line
  end
  arr << a
end

f.close
