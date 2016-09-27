require 'csv'
require 'sinatra'
require 'rspec'
require 'pry'
#tdd attempt at making a train display that will take a .csv file,
#sanetize it in some ways, then an organized list of trains and schedules.


#controller
class TrainDisplay

  def open(file_path)
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

  #this could also be cleaner, feedback appreciated.  
  #I'd like to not have to convert to array to sort, not sure that's possible.
  def sort(csv_table, organize_by=:run_number)
    sorting_array = []
    csv_table.each { |row| sorting_array.push(row)}
    sorting_array.sort_by! { |row| row[organize_by]}
    return CSV::Table.new(sorting_array)
  end

  #runs the above functions for sinatra display
  def schedule_open_and_display(file_path)
    schedule = open(file_path)
    schedule = make_entries_unique(schedule)
    schedule = delete_empty_rows(schedule)
    sort(schedule)
  end

  def upload(filename, file)
    File.open("lib/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
  end

end

#sinatra
get '/' do
  redirect '/upload'
end

#this should be touched up by adding a method or page that allows you 
#to select all uploaded schedules
get '/first_schedule' do
  @table_schedule = TrainDisplay.new.schedule_open_and_display('lib/trains.csv')
  binding.pry
  erb :table_view 
end

get '/upload' do
  erb :upload
end

#saves new CSVs to /lib/[filename]
#todo: test this method
post '/upload' do 
  filename = params[:file][:filename]
  file = params[:file][:tempfile]
  obj = TrainDisplay.new.upload(filename, file)

  @table_schedule = TrainDisplay.new.schedule_open_and_display("lib/#{@filename}")
  erb :table_view
end


#tests
describe TrainDisplay do
  describe "#open" do
    it "creates a table CSV object from a file uploaded to lib adding headers" do
      schedule = TrainDisplay.new
      expect(schedule.open('lib/trains.csv')).to be_instance_of(CSV::Table)
    end
  end

  describe "#sort" do
    it "organizes values based on a passed in header value" do
      schedule = TrainDisplay.new
      sample_table = CSV.parse("Name,Age\nMaria,95\nDerek,55\nDanielle,22\nJose,1", headers: true)
      expect(schedule.sort(sample_table, "Age").first["Age"]).to eq("1")
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

  describe "#schedule_open_and_display" do
    it "runs all the sanetize and open function in a neat package for sinatra readability" do
      schedule = TrainDisplay.new
      expect(schedule.open('lib/trains.csv')).to be_instance_of(CSV::Table)
    end
  end

end