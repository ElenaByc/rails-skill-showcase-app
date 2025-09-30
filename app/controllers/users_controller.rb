class UsersController < ApplicationController
  def dashboard
    @user = User.find(params[:id])
    @certificates = @user.certificates
    @skills = @user.unique_skills
    @issuers = @user.unique_issuers
  end

  def showcase
    @user = User.find(params[:id])
    @certificates = @user.certificates.includes(:skills, :issuer)
    @skills = @user.unique_skills
  end
end
