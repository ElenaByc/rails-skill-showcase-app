class SkillsController < ApplicationController
  def user_index
    @user = User.find(params[:id])
    @skills = Skill.where(created_by: @user.id).includes(:certificates)
  end
end