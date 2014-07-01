require 'sinatra'

get '/' do
  "Hello world!\n"
end

post '/games' do
end

get '/games/:game' do |game_id|
end
