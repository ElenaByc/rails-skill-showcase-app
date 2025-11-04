class CertificatesController < ApplicationController
  before_action :require_login, only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_certificate, only: [ :show, :edit, :update, :destroy ]
  before_action :check_ownership, only: [ :edit, :update, :destroy ]

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
    @user = current_user
    @user_issuers = @user&.created_issuers
    @user_skills = @user&.created_skills
  end

  def create
    @certificate = Certificate.new
    @certificate.user_id = current_user&.id

    # Assign attributes and skills BEFORE save so validation can see them
    skill_ids = certificate_params[:skill_ids] || []
    @certificate.assign_attributes(certificate_params.except(:skill_ids))
    @certificate.skill_ids = skill_ids

    if @certificate.save
      redirect_to dashboard_path, notice: "Certificate was successfully created."
    else
      @user = current_user
      @user_issuers = @user&.created_issuers
      @user_skills = @user&.created_skills
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @user = @certificate.user
    # Get user from URL parameter for now (will change with authentication)
    user_id = params[:user_id] || @certificate.user_id
    @user_issuers = User.find(user_id).created_issuers
    @user_skills = User.find(user_id).created_skills
  end

  def update
    Rails.logger.debug "Updating certificate #{@certificate.id} with params: #{certificate_params.inspect}"

    # Assign attributes and skills BEFORE save so validation can see them
    skill_ids = certificate_params[:skill_ids] || []
    @certificate.assign_attributes(certificate_params.except(:skill_ids))
    @certificate.skill_ids = skill_ids

    if @certificate.save
      Rails.logger.debug "Certificate updated successfully, redirecting to dashboard"
      redirect_to dashboard_path, notice: "Certificate was successfully updated."
    else
      @user = @certificate.user
      # Get user from URL parameter for now (will change with authentication)
      user_id = params[:user_id] || @certificate.user_id
      @user_issuers = User.find(user_id).created_issuers
      @user_skills = User.find(user_id).created_skills
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @certificate.destroy
    redirect_to dashboard_path, notice: "Certificate was successfully deleted."
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
    current_user_id = current_user&.id
    unless current_user_id && current_user_id.to_i == @certificate.user_id
      redirect_to certificate_path(@certificate), alert: "You can only edit or delete your own certificates."
    end
  end

  def certificate_params
    permitted = params.require(:certificate).permit(:name, :issued_on, :verification_url, :issuer_id, :image_url, skill_ids: [])
    # Filter out empty skill_ids and convert to integers
    if permitted[:skill_ids]
      permitted[:skill_ids] = permitted[:skill_ids].reject(&:blank?).map(&:to_i)
    end
    permitted
  end
end
