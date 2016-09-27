require 'csv'
require 'sinatra'
require 'rspec'
require 'pry'
#tdd attempt at making a train display that will take a .csv file,
#sanetize it in some ways, then an organized list of trains and schedules.


#controller
class TrainDisplay

  def open(file_path='lib/trains.csv')
    @table_schedule = CSV.table(file_path, headers: true)
  end

  #I want this code to be cleaner, but dont' know how to make it so, feedback appreciated
  def make_entries_unique(csv_table)
    comparison_entries = []
    csv_table.delete_if do |row|
      if comparison_entries.include?(row.inspect)
        true
      else
        comparison_entries.push(row.inspect)
        false
      end
    end
  end

  def delete_empty_rows(csv_table)
    csv_table.delete_if do |row| 
      row.to_hash.values.join.strip.empty? || nil?
    end
  end

  #it was hard to sort and maintain the CSV::table structure, so this returns an array
  #this function should be run last before display
  def sort(csv_table, organize_by="RUN_NUMBER")
    csv_table.read.sort_by{ |row| row[organize_by] }
  end

end

#sinatra
get '/' do
  redirect '/upload'
end

#this should be touched up by adding a method or page that allows you 
#to select uploaded schedules
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

  describe "#sort" do
    it "organizes values based on a header value" do
      schedule = TrainDisplay.new
      sample_table = CSV.parse("Name,Age\nMaria,95\nDerek,55\nDan,34", headers: true)
      expect(schedule.sort(sample_table, :Age).first.inspect).to equal("#<CSV::Row \"Name\":\"Dan\" \"Age\":\"34\">")
    end
  end

  describe "#make_entries_unique" do
    it "deletes duplicate rows from a CSV::Table object" do
      schedule = TrainDisplay.new
      sample_table = CSV.parse("Name,Age\nDan,34\nMaria,55\nDan,34\n    ,  ", headers: true)
      expect(schedule.make_entries_unique(sample_table).length).to equal(3)
    end
  end

  describe "#delete_empty_rows" do
    it "deletes empty rows for a CSV::Table object" do
      schedule = TrainDisplay.new
      sample_table = CSV.parse("Name,Age\nDan,34\nMaria,55\n    ,  ", headers: true)
      expect(schedule.delete_empty_rows(sample_table).length).to equal(2)
    end
  end

end