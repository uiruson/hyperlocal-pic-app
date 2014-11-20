require 'pry'
require 'exifr'
require 'instagram'
require 'geo-distance'

enable :sessions

helpers do
  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end
end

# Homepage (Root path)
get '/' do
  erb :index
end

get '/login' do
end

get '/signup' do
end

get '/logout' do
  session.clear
end

get '/upload' do
end

get '/delete_photo' do
end

