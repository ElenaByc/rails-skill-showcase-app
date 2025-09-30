class IssuersController < ApplicationController
  def user_index
    @user = User.find(params[:id])
    @issuers = Issuer.where(created_by: @user.id).includes(:certificates)
  end
end