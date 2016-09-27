require 'csv'
require 'sinatra'
require 'rspec'
require 'pry'
#tdd attempt at making a train display that will take a .csv file and return
#an organized list of trains and schedules.

#controller
class TrainDisplay
  
  def open_csv(file_path='files/trains.csv')
    binding.pry
    CSV.open(file_path, headers: true, skip_blanks: true).read
  end

  #this sort should be better, but I'm running out of time.
  def sort(file_path='files/trains.csv')
    rows = []
    CSV.foreach(file_path, headers: true) do |row|
      rows << row.to_h
    end
    binding.pry
    rows.sort_by{ |row| row['RUN_NUMBER'] }
  end

end

#sinatra
get '/' do
  redirect '/upload'
end

get '/schedule' do 
  binding.pry
  #this should be touched up by adding a method or page that allows you to select uploaded
  #schedules
  @table_schedule = TrainDisplay.new.open_csv
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
  @table_schedule = TrainDisplay.new.open_csv("files/#{@filename}")
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