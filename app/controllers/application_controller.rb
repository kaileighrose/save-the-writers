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
    erb :'users/login'
  end

  get '/signup' do
    if !logged
    erb :'users/create_user'
  end

  post '/signup' do
    user = User.new(:username => params[:username], :password => params[:password])
    if user.save
        redirect "/login"
    else
        redirect "/failure"
    end
  end

  get 'resources/:id' do
    @resource = Resource.find_by_id(params[:id])
    erb :'resources/show_resource'
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to "/tweets"
    else
        redirect to "/failure"
    end
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