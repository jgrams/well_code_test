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
  def sanitize_csv(file_path='files/trains.csv', organize_by="RUN_NUMBER")
    @table_schedule = CSV.foreach(file_path, headers: true) do |row|
      #if a joined string (stripped of whitespace) of all the values for a row is empty or nil, delete the row
      if row.to_hash.values.join.strip.empty? || nil?
        row.delete
      else
        row
      end
    end
  end

  def sort(csv_table)
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

#saves new CSVs to /files
post '/upload' do 
  @filename = params[:file][:filename]
  file = params[:file][:tempfile]
  File.open("files/#{@filename}", 'wb') do |f|
    f.write(file.read)
  end
  TrainDisplay.new.sanitize_csv("files/#{@filename}")
  erb :table_view
end


#tests
describe TrainDisplay do
  describe "#sanitize_csv" do
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