require 'csv'
require 'sinatra'
require 'rspec'
require 'pry'
#tdd attempt at making a train display that will take a .csv file and return
#an organized list of trains and schedules.

#controller
class TrainDisplay
  
  def open(file_path='files/trains.csv')
    @table_schedule = CSV.open(file_path, :headers => true)
  end

end

#sinatra
get '/schedule' do 
  binding.pry
  #this should be touched up if this is expanded at all, it'll break things down the road
  #as soon as I add anything else to params
  if !params.empty?
    @table_schedule = TrainDisplay.new.open('files/' << params[:filename])
  else
    @table_schedule = TrainDisplay.new.open
  end
  erb :table_view 
end

get '/upload' do
  erb :upload
end

post "/upload" do 
  binding.pry
  File.open('files/' + params['file'][:filename], "w") do |f|
    f.write(params['file'][:tempfile].read)
  end
  redirect '/schedule'
  binding.pry
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