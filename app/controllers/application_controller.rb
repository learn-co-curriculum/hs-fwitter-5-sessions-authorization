require_relative "../../config/environment"

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'fwitter'
  end

  helpers do
    def signed_in?
      session[:id]
    end

    def current_user
      current_user = User.find(session[:id])
    end

    def error
      session[:error]
    end
  end

  get '/tweets' do
    @tweets = Tweet.all
    @users = User.all
    erb :tweets
  end

  post '/tweets' do
    Tweet.create(:user_id => params[:user_id], :status => params[:status])
    redirect '/tweets'
  end

  get '/users' do
    @users = User.all
    erb :users
  end

  post '/users' do
    @user = User.create(name: params[:name], email: params[:email])
    session[:id] = @user.id
    redirect '/users'
  end

  get '/sign-in' do
    @signin = true
    erb :signin
  end

  post '/sign-in' do
    @user = User.find_by(email: params[:email], name: params[:name])
    # "#{@user.name}"
    if @user
      session[:id] = @user.id
    end
    redirect '/users'
    # if @user && @user.name == params[:name]
    #   session[:id] = @user.id
    #   session[:error] = nil
    #   redirect '/users'
    # else
    #   session[:error] = "There is no user with that email address. Try again or sign up below."
    #   redirect '/sign-in'
    # end
  end

  get '/sign-out' do
    session[:id] = nil
    session[:error] = nil
    redirect '/tweets'
  end
end