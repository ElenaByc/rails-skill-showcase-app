class UsersController < ApplicationController
  def dashboard
    @user = User.find_by(id: params[:id])
    unless @user
      @user_id = params[:id]
      render :user_not_found, status: :not_found
      return
    end
    @certificates = @user.certificates
    @skills = @user.unique_skills
    @issuers = @user.unique_issuers
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
end
