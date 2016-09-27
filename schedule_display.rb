require 'csv'
require 'sinatra'
require 'rspec'
require 'pry'
#tdd attempt at making a train display that will take a .csv file and return
#an organized list of trains and schedules.

#controller
class TrainDisplay
  
  def open_sort_csv(file_path='files/trains.csv')
    rows = []
    CSV.foreach(file_path, headers: true) do |row|
      rows << row.to_h
    end
    rows.sort_by{ |row| row['RUN_NUMBER'] }
    rows
    binding.pry
  end

end

#sinatra
get '/' do
  redirect '/upload'
end

#this should be touched up by adding a method or page that allows you to select uploaded
#schedules
get '/first_schedule' do 
  binding.pry
  @table_schedule = TrainDisplay.new.open_sort_csv
  erb :table_view 
end

get '/upload' do
  erb :upload
end

post '/upload' do 
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]
  File.open("files/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  @table_schedule = TrainDisplay.new.open_sort_csv("files/#{@filename}")
  erb :table_view
end


#tests
describe TrainDisplay do
  describe "#open" do
    it "returns the contents of CSV file as a CSV ruby object" do
      schedule = TrainDisplay.new
      expect(schedule.open).to be_instance_of(CVS)
    end
  end

    describe "#sort" do
    it "sort the contents of a CSV file" do
      schedule = TrainDisplay.new
      expect(schedule.open).to be_instance_of(CVS)
    end
  end

end