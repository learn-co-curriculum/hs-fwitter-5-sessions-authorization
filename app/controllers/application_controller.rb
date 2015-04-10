require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'fwitter'
  end

  helpers do
    def signed_in?
      session[:user_id]
    end

    def current_user
      current_user = User.find(session[:user_id])
    end

    def error
      session[:error]
    end
  end

  get '/' do
    @tweets = Tweet.all
    @user = User.find_by(:id => session[:user_id])
    # @users = User.all
    erb :index
  end

  get '/tweet' do
    @user = User.find_by(:id => session[:user_id])
    # @users = User.all
    erb :tweet
  end

  post '/tweet' do
    Tweet.create(:user_id => params[:user_id], :status => params[:status])
    redirect '/'
  end

  get '/users' do
    @users = User.all
    erb :users
  end

  post '/sign-up' do
    @user = User.new(:name => params[:name], :email => params[:email])
    @user.save
    session[:user_id] = @user.id
    redirect '/'
  end

  get '/sign-in' do
    @signin_page = true
    erb :signin
  end

  post '/sign-in' do
    @user = User.find_by(:email => params[:email], :name => params[:name])
    if @user
      session[:user_id] = @user.id
    end
    redirect '/tweet'
  end

  # THIS METHOD IS FOR ADVANCED STUDENTS TRYING TO DO ERROR HANDLING
  # post '/sign-in' do
  #   @user = User.find_by(:email => params[:email], :name => params[:name])
  #   if @user
  #     session[:user_id] = @user.id
  #   end
  #   redirect '/tweet'
  #   if @user && @user.name == params[:name]
  #     session[:user_id] = @user.id
  #     session[:error] = nil
  #     redirect '/tweets'
  #   else
  #     session[:error] = "There is no user with that email address. Try again or sign up below."
  #     redirect '/sign-in'
  #   end
  # end

  get '/sign-out' do
    session[:user_id] = nil
    session[:error] = nil
    redirect '/'
  end
end
