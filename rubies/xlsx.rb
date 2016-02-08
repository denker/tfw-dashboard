require 'axlsx'

def make_xlsx(visits)

  widths = [12]*3 + [nil]*10
  types = [:date,:time,:time] + [nil]*10
  columns = { :work_date => 'Дата', :started_at => 'Пришли', :finished_at => 'Ушли', :male => 'М', :female => 'Ж',
              :revenue => 'Сумма', :bycard => 'Картой', :tips => 'Чаевые', :age => 'Возраст', :if_snacks => 'Закусь?',
              :if_hot_meal => 'Горячее?', :if_first_visit => 'Впервые?', :comment => 'Комментарий' }

  p = Axlsx::Package.new
  p.workbook.add_worksheet(:name => "Визиты") do |sheet|
    sheet.add_row columns.values
    Visit.all.each do |visit|
      data = []
      columns.keys.each do |k|
        value = k != :work_date ? visit[k] : DateTime.get_work_date(visit.started_at)
        data << value
      end
      sheet.add_row(data, { types: types, widths: widths })
    end
  end
  return p

end
