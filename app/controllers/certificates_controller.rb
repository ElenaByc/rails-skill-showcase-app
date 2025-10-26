class CertificatesController < ApplicationController
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
    @user_id = params[:user_id]
    @user = User.find(@user_id) if @user_id
    @user_issuers = @user.created_issuers if @user
    @user_skills = @user.created_skills if @user
  end

  def create
    @certificate = Certificate.new(certificate_params.except(:skill_ids))
    @certificate.user_id = params[:user_id]

    if @certificate.save
      # Assign skills after certificate is saved
      skill_ids = certificate_params[:skill_ids] || []
      @certificate.skill_ids = skill_ids
      redirect_to user_dashboard_path(@certificate.user), notice: "Certificate was successfully created."
    else
      @user_id = params[:user_id]
      @user = User.find(@user_id) if @user_id
      @user_issuers = @user.created_issuers if @user
      @user_skills = @user.created_skills if @user
      # Preserve skill selection for form re-render
      @certificate.skill_ids = certificate_params[:skill_ids] || []
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

    if @certificate.update(certificate_params.except(:skill_ids))
      # Update skills after certificate is updated
      skill_ids = certificate_params[:skill_ids] || []
      @certificate.skill_ids = skill_ids
      Rails.logger.debug "Certificate updated successfully, redirecting to dashboard"
      redirect_to user_dashboard_path(@certificate.user), notice: "Certificate was successfully updated."
    else
      @user = @certificate.user
      # Get user from URL parameter for now (will change with authentication)
      user_id = params[:user_id] || @certificate.user_id
      @user_issuers = User.find(user_id).created_issuers
      @user_skills = User.find(user_id).created_skills
      # Preserve skill selection for form re-render
      @certificate.skill_ids = certificate_params[:skill_ids] || []
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
    permitted = params.require(:certificate).permit(:name, :issued_on, :verification_url, :issuer_id, skill_ids: [])
    # Filter out empty skill_ids and convert to integers
    if permitted[:skill_ids]
      permitted[:skill_ids] = permitted[:skill_ids].reject(&:blank?).map(&:to_i)
    end
    permitted
  end
end
