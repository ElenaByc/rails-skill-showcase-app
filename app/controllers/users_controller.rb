class UsersController < ApplicationController
  before_action :require_login, only: [ :dashboard ]
  before_action :redirect_if_logged_in, only: [ :new ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # Registration successful - automatically log them in
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Account created successfully!"
    else
      # Registration failed - show errors
      render :new, status: :unprocessable_entity
    end
  end

  def dashboard
    @user = User.find(session[:user_id])
    @certificates = @user.certificates
  end

  def showcase
    @user = User.find_by(id: params[:id])
    unless @user
      @user_id = params[:id]
      render :user_not_found, status: :not_found
      return
    end
    @certificates = @user.certificates.includes(:skills, :issuer)
    @skills = @user.unique_skills
  end

  private

  def redirect_if_logged_in
    if logged_in?
      redirect_to dashboard_path
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
