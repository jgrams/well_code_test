require 'csv'
require 'sinatra'
require 'rspec'
require 'pry'
#tdd attempt at making a train display that will take a .csv file and return
#an organized list of trains and schedules.

#improvements:
#sanitize uploads rather than sanetizing upon display

#controller
class TrainDisplay
  #returns a CSV table that's been sanitized and organized
  def open(file_path='lib/trains.csv', organize_by="RUN_NUMBER")
    @table_schedule = CSV.table(file_path, headers: true) do |row|
      #if a joined string (stripped of whitespace) of all the values for a row is empty or nil, delete the row
      if row.to_hash.values.join.strip.empty? || nil?
        row.delete
      else
        row
      end
    end
  end

  def sort(opened_csv_table)
  end

  def unique_entries(opened_csv_table)
  end

  def delete_
  end

  def open_sort_csv(file_path='lib/trains.csv')
    CSV.open(file_path, headers: true).read
>>>>>>> 308969c1551b7edb3cc18f198f67ef8dfe53c5af
  end

end

#sinatra
get '/' do
  redirect '/upload'
end

#this should be touched up by adding a method or page that allows you to select uploaded
#schedules
get '/first_schedule' do 
  TrainDisplay.new.sanitize_csv
  erb :table_view 
end

get '/upload' do
  erb :upload
end

#saves new CSVs to /lib
post '/upload' do 
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]
  File.open("lib/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  TrainDisplay.new.sanitize_csv("lib/#{@filename}")
  @table_schedule = TrainDisplay.new.open_sort_csv("lib/#{@filename}")
  erb :table_view
end


#tests
describe TrainDisplay do
  describe "#open" do
    it "strips empty rows from a CSV object" do
      schedule = TrainDisplay.new
      expect(schedule.sanitize_csv).to be_instance_of(CSV::Table)
    end
  end

    describe "#sort" do
    it "returns the contents of CSV file as a CSV ruby object" do
      schedule = TrainDisplay.new
      expect(schedule.open_sort_csv).to be_instance_of(CSV::Table)
    end
  end

end