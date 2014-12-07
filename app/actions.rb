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

  def get_stored_pictures(id)
    if current_user
      @user = @current_user
      @pictures = Picture.where(user_id: @user.id)

      if @pictures.length >= 4 
        @pictures = Picture.where(user_id: @user.id).order('created_at desc').limit(4)
      elsif @pictures.length < 4
        @pictures = @pictures.order("created_at desc")

        while ( @pictures.length < 4)
          @pic = Picture.new(user_id: @user.id, photo_path: '/images/placeholder.png')
          @pictures.push(@pic)
        end
      end

      if !id.nil?
        display_instagram_pics(id) if @user.pictures.count > 0
      end
    end
  end

  def temporary_map
    # gon.your_json = geolocationHash.to_json
    # 49.283139, -123.120488
  end

  def display_instagram_pics(id)
    selectedPic = current_user.pictures.where(id: id).first
    @descending_location = []
    geolocationHash = {}
    geolocationHash[:origins] = []
    geolocationHash[:markers] = []
    geolocationHash[:images] = []
    origin = {}
 
    Instagram.configure do |config|
      config.client_id = settings.instagram_id
      config.client_secret = settings.instagram_secret
    end
    
    @html = "<div class='container' id='instagramImagesContainer'>"
    @html << "<h2>LIST OF NEARBY IMAGES</h2><div class='row'>"

    lat1 = selectedPic.latitude
    lon1 = selectedPic.longitude
    origin["latitude"] = lat1
    origin["longitude"] = lon1
    geolocationHash[:origins].push(origin)

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
    erb :'/main'
  end
end

get '/' do
  erb :index
end

get '/main' do 
  if current_user
    get_stored_pictures(nil)
    erb :'/main'
  end
end

post '/login' do
  @user = User.where(username: params[:username]).first
  if @user && params[:password] == @user.password
    session[:user_id] = @user.id
    if @user.pictures.count > 0
      redirect "/instagram_images/#{@user.pictures.last.id}"
    else
      redirect '/main'
    end
  else
    erb :index
  end
end


post '/signup' do
  @user = params[:username] ? User.new(username: params[:username],email: params[:email],password: params[:password]) : User.new_guest

  if @user.save
    #current_user.move_to(@user) if current_user && current_user.is_guest?
    session[:user_id] = @user.id
    redirect '/main'
  else
    erb :index
  end

end

get '/logout' do
  if !current_user.is_guest?
    session.clear
    redirect '/'
  else
    User.destroy(current_user.id)
    session.clear
    redirect '/'
  end
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
      @picture_creds = Picture.create(
        photo_path: file_path,
        user_id: session[:user_id],
        latitude: @latitude,
        longitude: @longitude
      )
      redirect "/instagram_images/#{current_user.pictures.last.id}"
    else
      if current_user.pictures.count > 0
        flash[:message] = "**UPLOAD FAILED**<br/>Your picture doesn't have any GPS data !"
        redirect "/instagram_images/#{current_user.pictures.last.id}"
      else
        flash[:message] = "**UPLOAD FAILED**<br/>Your picture doesn't have any GPS data !"
        redirect "/main"
      end
    end
  else
    if current_user.pictures.count > 0
      flash[:message] = "**UPLOAD FAILED**<br/>You need to upload a jpg file"
      redirect "/instagram_images/#{current_user.pictures.last.id}"
    else
      flash[:message] = "**UPLOAD FAILED**<br/>You need to upload a jpg file"
      redirect '/main'
    end
  end
  erb :'/main'
end


get '/instagram_images/:id' do
  get_stored_pictures(params[:id])
end


get '/delete_photo' do
end
