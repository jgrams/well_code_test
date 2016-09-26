require "rspec"
require "csv"
#tdd attempt at making a train display that will take a .csv file and return
#an organized list of trains and schedules.

class TrainDisplay
  
  def open(file_path="trains.csv")
    @csv_table = CSV.open(file_path, :headers => true)
  end

end

describe TrainDisplay do
  describe "#open" do
    it "returns the contents of CSV file as a CSV ruby object" do
      schedule = TrainDisplay.new
      expect(schedule.open).to be_instance_of(CSV)
    end
  end

  describe "#title_line" do
    it "returns an HTML table based on " do
      schedule = TrainDisplay.new
      expect(schedule.open.title_line).to equal("TRAIN_LINE, ROUTE_NAME, RUN_NUMBER, OPERATOR_ID")
    end
  end  
end