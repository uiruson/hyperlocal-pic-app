
require 'exifr'
require 'instagram'
require 'geo-distance'
require 'gon-sinatra'
require 'json'
require 'sinatra/flash'

enable :sessions

helpers do
  def current_user
    if session[:user_id]
      @current_user = User.find(session[:user_id])
    end
  end
  def click_picture(pic)
    @recent_pic_upload = Picture.last
    @secondlast_upload = Picture.all[-2]
    @thirdlast_upload = Picture.all[-3]
    @fourthlast_upload = Picture.all[-4]
 
    Instagram.configure do |config|
      config.client_id = settings.instagram_id
      config.client_secret = settings.instagram_secret
    end
    # binding.pry
    lat1 = pic.latitude
    lon1 = pic.longitude

    @html = "<div class='container' id='instagramImagesContainer'>"
    @html << "<h2>LIST OF NEARBY IMAGES</h2><div class='row'>"


    @descending_location = []
    geolocationHash = {}
    origin = {}
    origin["latitude"] = lat1
    origin["longitude"] = lon1
    geolocationHash[:origins] = []
    geolocationHash[:origins].push(origin)
    geolocationHash[:markers] = []
    geolocationHash[:images] = []
    for media_item in Instagram.media_search(lat1, lon1, {:count => 15, :distance => 1200})
      lat2 = media_item.location.latitude
      lon2 = media_item.location.longitude
      temphash = {}
      temphash["latitude"] = lat2
      temphash["longitude"] = lon2
      geolocationHash[:markers].push(temphash)
      imagehash = {}
      imagehash["src"] = "#{media_item.images.thumbnail.url}"
      geolocationHash[:images].push(imagehash)
      dist = GeoDistance::Haversine.distance( lat1.to_f, lon1.to_f, lat2.to_f, lon2.to_f ).meters.number
      @descending_location << {item: media_item, distance: (dist/1000).round(2)}
    end
    @descending_location = @descending_location.sort_by {|k| k[:distance]}
    @descending_location.each do |item|

      @html << "<div class='col-md-2'><span>Distance: #{item[:distance]}km</span><br/>
                <img src='#{item[:item].images.thumbnail.url}'/ style='margin-bottom:15px;border: 7px solid white;'>
              </div>"
    end
    @html << "</div></div>"

    gon.your_json = geolocationHash.to_json
    # File.open(File.join(__dir__, "/../public/javascript/location.json"),"w+") do |f|
    #   f.write(geolocationHash.to_json)
    #   f.close
    # end
    erb :'/main'
    # if session[:message] != ""
    #   session[:message] == ""
    # end
  end
end

get '/' do
  erb :index
end

get '/login' do
  redirect '/instagram_images/'
end

get '/signup' do

  erb :'/upload'
end

post '/signup' do
  @user = User.create!(
    username: params[:username],
    password: params[:password]
  )
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
  redirect '/'
end

get '/upload' do
  current_user
  erb :'/main'
end

post '/upload' do

  file_path = 'uploads/' + params['myfile'][:filename]

  File.open('public/' + file_path, "w") do |f|
    f.write(params['myfile'][:tempfile].read)
  end

  if params['myfile'][:type].match(/(jpg|jpeg)$/)
    if EXIFR::JPEG.new('public/' + file_path).exif? && EXIFR::JPEG.new('public/' + file_path).gps != nil
      exif = EXIFR::JPEG.new('public/' + file_path)
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
      flash[:message] = "**UPLOAD FAILED**<br/>Your picture doesn't have any GPS data !"
      redirect '/instagram_images'
    end
  else
    flash[:message] = "**UPLOAD FAILED**<br/>You need to upload a jpg file"
    redirect '/instagram_images'
  end
  erb :'/main'
end

get '/instagram_images' do
  if Picture.count > 0
    pic = Picture.last
    click_picture(pic)
  else
    erb :'/main'
  end
end

get '/instagram_images/:id' do
  pic = Picture.find(params[:id])
  click_picture(pic)
end


get '/delete_photo' do
end
