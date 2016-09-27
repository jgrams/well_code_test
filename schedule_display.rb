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
  def open(file_path='lib/trains.csv')
    @table_schedule = CSV.table(file_path, headers: true)
  end

  def sort(opened_csv_table, organize_by="RUN_NUMBER")
  end

  def unique_entries(opened_csv_table)
  end

  def delete_empty_rows(opened_csv_table)
    opened_csv_table.delete_if do |row| 
      row.to_hash.values.join.strip.empty? || nil?
    end
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
  @table_schedule = TrainDisplay.new.open("lib/#{@filename}")
  erb :table_view
end


#tests
describe TrainDisplay do
  describe "#open" do
    it "creates a table CSV object from a file uploaded to lib" do
      schedule = TrainDisplay.new
      expect(schedule.open).to be_instance_of(CSV::Table)
    end
  end

  # describe "#sort" do
  #   it "creates a table CSV object from a file uploaded to lib" do
  #     schedule = TrainDisplay.new
  #     expect(schedule.sanitize_csv).to be_instance_of(CSV::Table)
  #   end
  # end

  describe "#unique_entries" do
    it "deletes duplicate rows from a CSV::Table object" do
      schedule = TrainDisplay.new
      sample_table = CSV.parse("Name,Age\nDan,34\nMaria,55\nDan,34\n    ,  ", headers: true)
      expect(schedule.uniqie_entries(sample_table).length).to equal(3)
    end
  end

  describe "#delete_empty_rows" do
    it "deletes empty rows for a CSV::Table object, returns empty rows" do
      schedule = TrainDisplay.new
      sample_table = CSV.parse("Name,Age\nDan,34\nMaria,55\n    ,  ", headers: true)
      expect(schedule.delete_empty_rows(sample_table).length).to equal(2)
    end
  end

end