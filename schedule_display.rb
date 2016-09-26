require "rspec"
#tdd attempt at making a train display that will take a .csv file and return
#an organized list list of trains and schedules.

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
      expect(schedule.open).should be_a(String)
    end
  end
end