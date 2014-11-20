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
  Instagram.configure do |config|
    config.client_id = settings.instagram_id
    config.client_secret = settings.instagram_secret
  end

  lat1 = "49.282111111111114".to_f
  lon1 = "-123.10839722222222".to_f
  #id = Instagram.media_search(lat1, lon1)

  @html = "<h1>Get a list of media close to a given latitude and longitude</h1>"
  for media_item in Instagram.media_search(lat1, lon1, {:count => 30, :distance => 10, :MIN_TIMESTAMP => 1})
    lat2 = media_item.location.latitude
    lon2 = media_item.location.longitude

    dist = GeoDistance::Haversine.distance( lat1.to_f, lon1.to_f, lat2.to_f, lon2.to_f ).meters.number

    #puts "dist = #{dist}"
    @html << "<div class='col-md-3'>Distance: #{(dist/1000).round(2)}km<br/><br/><img src='#{media_item.images.thumbnail.url}'></div>"
  end
  @html
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

