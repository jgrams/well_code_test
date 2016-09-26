require "rspec"
#tdd attempt at making a train display that will take a .csv file and return
#an organized list list of trains and schedules.

class TrainDisplay
  
  def open
  end
  
end

describe TrainDisplay do
  #describe can be swapped out for "context" depending on the context
  describe "#open" do
    it "returns the contents of CSV file" do
      schedule = TrainDisplay.new
      expect(schedule.open(5, 10)).should be_a(String)
    end
  end
end