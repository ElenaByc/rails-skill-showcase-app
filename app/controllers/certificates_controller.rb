class CertificatesController < ApplicationController
  before_action :set_certificate, only: [:show, :edit, :update, :destroy]
  before_action :check_ownership, only: [:edit, :update, :destroy]

  def index
    @certificates = Certificate.includes(:user, :issuer, :skills)
  end

  def show
    @user = @certificate.user
    # For now, we'll use URL parameter to determine if current user is the owner
    # In a real app, this would be current_user.id == @certificate.user_id
    @current_user_id = params[:user_id] || params[:id]
    @is_owner = @current_user_id && @current_user_id.to_i == @certificate.user_id
  end

  def new
    @certificate = Certificate.new
    @user_id = params[:user_id]
    @user = User.find(@user_id) if @user_id
  end

  def create
    @certificate = Certificate.new(certificate_params)
    @certificate.user_id = params[:user_id]

    if @certificate.save
      redirect_to user_dashboard_path(@certificate.user), notice: "Certificate was successfully created."
    else
      @user_id = params[:user_id]
      @user = User.find(@user_id) if @user_id
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = @certificate.user
  end

  def update
    if @certificate.update(certificate_params)
      redirect_to user_dashboard_path(@certificate.user), notice: "Certificate was successfully updated."
    else
      @user = @certificate.user
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user_id = @certificate.user_id
    @certificate.destroy
    redirect_to user_dashboard_path(user_id), notice: "Certificate was successfully deleted."
  end

  private

  def set_certificate
    @certificate = Certificate.find_by(id: params[:id])
    unless @certificate
      @user_id = params[:user_id] || params[:id]
      render :certificate_not_found, status: :not_found
    end
  end

  def check_ownership
    current_user_id = params[:user_id] || params[:id]
    unless current_user_id && current_user_id.to_i == @certificate.user_id
      redirect_to certificate_path(@certificate), alert: "You can only edit or delete your own certificates."
    end
  end

  def certificate_params
    params.require(:certificate).permit(:name, :issued_on, :verification_url, :issuer_id, skill_ids: [])
  end
end
