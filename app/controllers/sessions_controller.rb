class SessionsController < ApplicationController

  skip_before_action :authorized, only: [:new, :create, :welcome, :checkout, :about, :payment, :checkin, :check, :how_it_works, :FAQ, :process_checkin]


  def new
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])

        # line 14 (right under this comment) was in the original article but giving me an error message

        # sessions[:user_id] = @user.id

        # the error was that i hadn't created/defined a local variable/method named sessions, which is true, but it also
        # offered the suggestion to change it to 'session' which i did (see below), but i don't know if
        # this messes up anything ;-;

        session[:user_id] = @user.id

        redirect_to '/welcome'
    else
        redirect_to '/login'
    end

  end

  def login
  end

  def welcome
  end

  def about
  end

  def page_requires_login
    @stations = Station.all.order(identifier: :asc)
    @bikes = Bike.all.order(identifier: :asc)
  end

  def payment
  end

  def checkout
    if params[:station_identifier]
      p params[:station_identifier].to_i
      session[:station_identifier] = params[:station_identifier].to_i
    end
    @station = Station.find_by_identifier(session[:station_identifier])
  end

  def check
    b = Bike.find_by_identifier(params[:bikeid])
    p session[:station_identifier]
    p b.current_station_identifier
    if session[:station_identifier] == b.current_station_identifier
      current_user.update_attribute(:current_bike_id, params[:bikeid])
      b.update_attribute(:current_station_identifier, nil)
      redirect_to '/ride'
    else
      redirect_to '/checkout'
    end
  end

  def ride
    @bike = Bike.find_by_identifier(current_user.current_bike_id)
    @stations = Station.all.order(identifier: :asc)
    @bikes = Bike.all.order(identifier: :asc)
  end

  def about
  end

  def logout
    session[:user_id]= nil
    redirect_to '/welcome'
  end

  def how_it_works
  end

  def FAQ
  end

  def checkin
    @stations = Station.all.order(identifier: :asc)
  end

  def process_checkin
    @bike = Bike.find_by_identifier(current_user.current_bike_id)
    @bike.update_attribute(:current_station_identifier, params[:station_identifier])
  end

end
