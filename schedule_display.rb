require "rspec"
#tdd attempt at making a train display that will take a .csv file and return
#an organized list of trains and schedules.

class TrainDisplay
  
  def open(file_path="trains.csv")
    file = File.open(file_path)
    file.read
  end

end

describe TrainDisplay do
  describe "#open" do
    it "returns the contents of CSV file as a string" do
      schedule = TrainDisplay.new
      expect(schedule.open).to be_instance_of(String)
    end
  end

  describe "#title_line" do
    it "returns an HTML table based on " do
      schedule = TrainDisplay.new
      expect(schedule.open).to equal("TRAIN_LINE, ROUTE_NAME, RUN_NUMBER, OPERATOR_ID")
    end
  end  
end