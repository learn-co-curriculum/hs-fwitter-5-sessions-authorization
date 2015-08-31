require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    # In our configure block, we enable sessions and setup a session secret - this is required to allow us to write into the cookie. 
    enable :sessions
    set :session_secret, 'fwitter'
  end

  # these helper methods will make it easer to read our code later. 
  helpers do
    def signed_in? # we'll use this method to be true or false if there's a :user_id in our session
      session[:user_id]
    end

    def current_user # returns the user based on what's in the session
      current_user = User.find(session[:user_id])
    end

    def error # we can use this to store a custom error message
      session[:error]
    end
  end

  get '/' do
    @tweets = Tweet.all
    @user = User.find_by(:id => session[:user_id]) #we load up the user based on the session id. We could also use the current_user method above. 
    # @users = User.all
    erb :index
  end

  get '/tweet' do
    @user = User.find_by(:id => session[:user_id])
    # @users = User.all
    erb :tweet
  end

  post '/tweet' do
    Tweet.create(:user_id => params[:user_id], :status => params[:status]) #Here, we're now using the .create method - this is the same as using the .new method and then the .save method on a different line. 
    redirect '/'
  end

  get '/users' do
    @users = User.all
    erb :users
  end

  post '/sign-up' do
    @user = User.new(:name => params[:name], :email => params[:email])
    @user.save
    session[:user_id] = @user.id #when a user sign's up, we save their user id into our session. 
    redirect '/'
  end

  get '/sign-in' do #this route renders a form for the user to sign-in. 
    @signin_page = true
    erb :signin
  end

  post '/sign-in' do
    #First, we look for the user by their email address by name. 
    @user = User.find_by(:email => params[:email], :name => params[:name])
    if @user #if we find a user, we'll set the session[:user_id] to that user's id. 
      session[:user_id] = @user.id
    end
    redirect '/tweet'
  end

  # BONUS - ERROR HANDLING

  # post '/sign-in' do
  #   @user = User.find_by(:email => params[:email], :name => params[:name])
  #   if @user
  # #    Here, we're storing an error message in sessions as well. If we find the user, that error will be empty.
  #     session[:user_id] = @user.id
  #     session[:error] = nil 
  #     redirect '/tweets'
  #   else
  ##    Otherwise, we'll store a message telling the user they need to sign up. 
  #     session[:error] = "There is no user with that email address. Try again or sign up below."
  #     redirect '/sign-in'
  #   end
  # end

  get '/sign-out' do
    # Going to '/sign-out' simply clears all of the session data that we've been storing. 
    session[:user_id] = nil
    session[:error] = nil
    redirect '/'
  end
end
