class IssuersController < ApplicationController
  before_action :require_login, only: [:index, :new, :create, :edit, :update, :destroy]
  before_action :set_issuer, only: [ :show, :edit, :update, :destroy ]
  before_action :check_ownership, only: [ :edit, :update, :destroy ]

  def index
    @issuers = Issuer.all.includes(:creator)
  end

  def show
    @user = User.find(@issuer.created_by)
    @certificates = @issuer.certificates.includes(:user, :skills)
  end

  def new
    @issuer = Issuer.new
    @user_id = session[:user_id] # Get user ID from session
  end

  def create
    @issuer = Issuer.new(issuer_params)
    @issuer.created_by = session[:user_id] # Get user ID from session

    if @issuer.save
      redirect_to issuers_path, notice: "Issuer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @issuer.update(issuer_params)
      redirect_to issuers_path, notice: "Issuer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issuer.destroy
    redirect_to issuers_path, notice: "Issuer was successfully deleted."
  end

  def index
    @user = User.find(session[:user_id])
    unless @user
      @user_id = session[:user_id]
      render "users/user_not_found", status: :not_found
      return
    end
    @issuers = Issuer.where(created_by: @user.id).includes(:certificates)
  end

  private

  def set_issuer
    @issuer = Issuer.find_by(id: params[:id])
    unless @issuer
      @issuer_id = params[:id]
      render :issuer_not_found, status: :not_found
    end
  end

  def check_ownership
    current_user_id = session[:user_id]
    unless current_user_id && @issuer.created_by.to_s == current_user_id.to_s
      redirect_to issuers_path, alert: "You can only edit issuers you created."
    end
  end

  def issuer_params
    params.require(:issuer).permit(:name, :website_url, :logo_url, :description)
  end
end
