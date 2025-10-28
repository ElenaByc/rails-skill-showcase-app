class SessionsController < ApplicationController
  before_action :require_login, only: [ :destroy ]
  before_action :redirect_if_logged_in, only: [ :new ]

  def new
    # Show login form - no data needed
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      # Successful login
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Successfully logged in! Welcome, #{user.name}!"
    else
      # Invalid credentials
      flash[:alert] = "Invalid email or password."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Successfully logged out!"
  end

  private

  def redirect_if_logged_in
    if logged_in?
      redirect_to dashboard_path
    end
  end
end
