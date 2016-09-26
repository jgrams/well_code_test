require 'sinatra'
require '/schedule_display.rb'

get '/schedule' do 
  @table_schedule = TrainDisplay.new.open
end