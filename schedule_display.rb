require 'csv'
require 'sinatra'
require 'rspec'
#tdd attempt at making a train display that will take a .csv file and return
#an organized list of trains and schedules.

#controller
class TrainDisplay
  
  def open_sort_csv(file_path='files/trains.csv')
    CSV.open(file_path, headers: true).read
  end

end

#sinatra
get '/' do
  redirect '/upload'
end

#this should be touched up by adding a method or page that allows you to select uploaded
#schedules
get '/first_schedule' do 
  @table_schedule = TrainDisplay.new.open_sort_csv
  erb :table_view 
end

get '/upload' do
  erb :upload
end

#saves file and 
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
      expect(schedule.open).to be_instance_of(CSV)
    end
  end

end