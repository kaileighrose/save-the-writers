require './config/environment'
require './app/models/user'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :index 
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect to "/resources"
    end
  end

  get '/signup' do
    if !logged_in?
      erb(:'users/create_user')
    else
      redirect to "/resources"
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty?
      user = User.create(:username => params[:username], :password => params[:password])
      redirect "/login"
    else
      @error_message = 'bad'
      erb(:'users/create_user')
      # redirect "/failure"
    end
  end

  get '/resources' do
    if logged_in?
      @resources = current_user.resources
      erb :'/resources/all_resources'
    else
      redirect "/failure"
    end
  end

  get '/resources/new' do
    if logged_in?
      erb :'/resources/new'
    else
      redirect to "/login"
    end  
  end

  post '/resources' do
    if !params["name"].empty?
      @resource = current_user.resources.create(:name => params[:name], :category => params[:category], :link => params[:link], :source => params[:source], :cost => params[:cost], :notes => params[:notes])
      redirect to "/resources/#{@resource.id}"
    else
      redirect to '/failure'
    end
  end

  get '/resources/:id' do
    @resource = Resource.find_by_id(params[:id])
    erb :'resources/show_resource'
  end

  get '/resources/:id/edit' do
    @resource = Resource.find_by_id(params[:id])
    erb :'resources/edit'
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to "/resources"
    else
        redirect to "/failure"
    end
  end

  delete '/resources/:id/delete' do
    @resource = Resource.find_by_id(params[:id])
    if logged_in? && session[:user_id] == @resource.user_id
      @resource.delete
      redirect to '/resources'
    else
      redirect to "/login"
    end
  end

  patch '/resources/:id' do
    @resource = Resource.find_by_id(params[:id])
    if !params["name"].empty?
      @resource.name = params["name"]
      @resource.save
    end
    if !params["category"].empty?
      @resource.category = params["category"]
      @resource.save
    end
    if !params["cost"].empty?
      @resource.cost = params["cost"]
      @resource.save
    end
    if !params["link"].empty?
      @resource.link = params["link"]
      @resource.save
    end
    if !params["source"].empty?
      @resource.source = params["source"]
      @resource.save
    end
    if !params["notes"].empty?
      @resource.notes = params["notes"]
      @resource.save
    end
    redirect to "resources/#{@resource.id}"
  end

  get "/failure" do
    erb :failure
  end

  get '/logout' do
    session.clear
    redirect to "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
end