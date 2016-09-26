require 'csv'
require 'sinatra'
require 'rspec'
require 'pry'
#tdd attempt at making a train display that will take a .csv file and return
#an organized list of trains and schedules.

#controller
class TrainDisplay
  
  def open(file_path="files/trains.csv")
    @table_schedule = CSV.open(file_path, :headers => true)
  end

end

#sinatra
get '/schedule' do 
  @table_schedule = @upload.open('files/' + params[:filename]) || TrainDisplay.new.open
  erb :table_view 
end

get '/upload' do
  erb :upload
end

post "/upload" do 
  File.open('files/' + params['file'][:filename], "w") do |f|
    f.write(params['file'][:tempfile].read)
  end
  redirect '/schedule'
end


#tests
describe TrainDisplay do
  describe "#open" do
    it "returns the contents of CSV file as a CSV ruby object" do
      schedule = TrainDisplay.new
      expect(schedule.open).to be_instance_of(CVS)
    end
  end
end