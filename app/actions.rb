require 'pry'
require 'exifr'
require 'instagram'
require 'geo-distance'
require 'gon-sinatra'
require 'json'

enable :sessions

helpers do
  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end
end

get '/' do
#  erb :index
# end

# get '/instagram_images' do
  Instagram.configure do |config|
    config.client_id = settings.instagram_id
    config.client_secret = settings.instagram_secret
  end

  lat1 = "49.282111111111114".to_f  #will get value passed in by uploaded image
  lon1 = "-123.10839722222222".to_f #will get value passed in by uploaded image
  # lat1 = "35.802547".to_f  #will get value passed in by uploaded image
  # lon1 = "139.789519".to_f #will get value passed in by uploaded image

  @html = "<h1>List of images close to a given latitude and longitude</h1>"
  @html << "<div class='container'><div class='row'>"
  #distance 10 = 10meter, 1000 = 1km
  geolocationHash = {}
  origin = {}
  origin["latitude"] = lat1
  origin["longitude"] = lon1
  geolocationHash[:origins] = []
  geolocationHash[:origins].push(origin)
  geolocationHash[:markers] = []
  geolocationHash[:images] = []
  for media_item in Instagram.media_search(lat1, lon1, {:count => 20, :distance => 100, :MIN_TIMESTAMP => 1})
    lat2 = media_item.location.latitude
    lon2 = media_item.location.longitude

    latlonghash = {}
    latlonghash["latitude"] = lat2
    latlonghash["longitude"] = lon2
    geolocationHash[:markers].push(latlonghash)
    imagehash = {}
    imagehash["src"] = "#{media_item.images.thumbnail.url}"
    geolocationHash[:images].push(imagehash)
    dist = GeoDistance::Haversine.distance( lat1.to_f, lon1.to_f, lat2.to_f, lon2.to_f ).meters.number

    @html << "<div class='col-md-2'>Distance: #{(dist/1000).round(2)}km<br/><br/>lat = #{lat2.to_f}, lon = #{lon2.to_f}<br/><br/>
                <img src='#{media_item.images.thumbnail.url}' />
              </div>"
  end
  @html << "</div></div>"

  File.open(File.join(__dir__, "/../public/javascript/location.json"),"w+") do |f|
    f.write(geolocationHash.to_json)
    f.close
  end
  erb :index
end

get '/login' do
  erb :'/upload'
end

get '/signup' do

  erb :'/upload'
end

post '/signup' do
  @user = User.create!(
    username: params[:username],
    password: params[:password]
  )
  # session[:user_id] = @user.id
  # @current_user = session[:user_id]
  redirect '/upload'
end

post "/login" do
  @user = User.where(username: params[:username], password: params[:password]).first
  if @user
    session[:user_id] = @user.id
    redirect '/upload'
  else
    return "invalid username or password"
  end
end

get '/logout' do
  session.clear
end

get '/upload' do
  current_user
  erb :"/upload"
end

post '/upload' do

  # binding.pry
  file_path = 'uploads/' + params['myfile'][:filename]
  # pic_resize = params['myfile'][:filename]
  # image = MiniMagick::Image.open(pic_resize)

  File.open('public/' + file_path, "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end

  if params['myfile'][:type].match(/(jpg|jpeg)$/)
    if EXIFR::JPEG.new(file_path).exif? && EXIFR::JPEG.new(file_path).gps != nil
      exif = EXIFR::JPEG.new(file_path)
      @latitude = exif.gps.latitude
      @longitude = exif.gps.longitude
      # binding.pry
      @picture_creds = Picture.create(
        photo_path: file_path,
        user_id: session[:user_id],
        latitude: @latitude,
        longitude: @longitude
      )
      # binding.pry
      redirect'/instagram_images'
    else
      return "Sorry, try taking a picture with your location turned on!"
    end
  else
    return "you need to upload a jpeg"
  end
end

get '/instagram_images' do
  @pic_latitude = Picture.last[:latitude]
  @pic_longitude = Picture.last[:longitude]
  @recent_pic_upload = Picture.last
  @secondlast_upload = Picture.all[-2]
  @thirdlast_upload = Picture.all[-3]
  @fourthlast_upload = Picture.all[-4]
  @fifthlast_upload = Picture.all[-5]

  # binding.pry


  # @recent_pic_upload.resize(0.25)
  Instagram.configure do |config|
    config.client_id = settings.instagram_id
    config.client_secret = settings.instagram_secret
  end
  # binding.pry
  lat1 = @pic_latitude
  lon1 = @pic_longitude

  @html = "<h1>List of images close to a given latitude and longitude</h1>"
  @html << "<div class='container'><div class='row'>"
  #distance 10 = 10meter, 1000 = 1km
  # binding.pry
  @html_pic_display = "<h1>Last 5 Uploads</h1>"
  @html_pic_display << "<img src ='#{@recent_pic_upload.photo_path}'/> <img src ='#{@secondlast_upload.photo_path}'/> <img src ='#{@thirdlast_upload.photo_path}'/> <img src ='#{@fourthlast_upload.photo_path}'/> <img src ='#{@fifthlast_upload.photo_path}'/>"
  @descending_location = []
  geolocationHash = {}
  origin = {}
  origin["latitude"] = lat1
  origin["longitude"] = lon1
  geolocationHash[:origins] = []
  geolocationHash[:origins].push(origin)
  geolocationHash[:markers] = []

  for media_item in Instagram.media_search(lat1, lon1, {:count => 10, :distance => 5000, :MIN_TIMESTAMP => 1})
    lat2 = media_item.location.latitude
    lon2 = media_item.location.longitude
    temphash = {}
    temphash["latitude"] = lat2
    temphash["longitude"] = lon2
    geolocationHash[:markers].push(temphash)
    dist = GeoDistance::Haversine.distance( lat1.to_f, lon1.to_f, lat2.to_f, lon2.to_f ).meters.number
    @descending_location << {item: media_item, distance: (dist/1000).round(2)}
  end
  @descending_location = @descending_location.sort_by {|k| k[:distance]}
  @descending_location.each do |item|

    @html << "<div class='col-md-2'>Distance: #{item[:distance]}km<br/><br/>lat = #{item[:item].location.latitude.to_f}, lon = #{item[:item].location.longitude.to_f}<br/><br/>
                <img src='#{item[:item].images.thumbnail.url}' />
              </div>"
  end
  @html << "</div></div>"
  File.open(File.join(__dir__, "/../public/javascript/location.json"),"w+") do |f|
    f.write(geolocationHash.to_json)
    f.close
  end
  erb :index
end

get '/delete_photo' do
end
