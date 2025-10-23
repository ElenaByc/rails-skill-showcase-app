class SkillsController < ApplicationController
  before_action :set_skill, only: [ :show, :edit, :update, :destroy ]
  before_action :check_ownership, only: [ :edit, :update ]

  def index
    @skills = Skill.all.includes(:creator)
  end

  def show
    @user = User.find(@skill.created_by)
    @certificates = @skill.certificates.includes(:user, :issuer)
  end

  def new
    @skill = Skill.new
    @user_id = params[:id] # Get user ID from the route parameter
  end

  def create
    @skill = Skill.new(skill_params)
    @skill.created_by = params[:id] # Get user ID from the route parameter

    if @skill.save
      redirect_to user_skills_path(params[:id]), notice: "Skill was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @skill.update(skill_params)
      redirect_to user_skills_path(@skill.created_by), notice: "Skill was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    user_id = params[:user_id] || @skill.created_by
    @skill.destroy
    redirect_to user_skills_path(user_id), notice: "Skill was successfully deleted."
  end

  def user_index
    @user = User.find_by(id: params[:id])
    unless @user
      @user_id = params[:id]
      render "users/user_not_found", status: :not_found
      return
    end
    @skills = Skill.where(created_by: @user.id).includes(:certificates)
  end

  private

  def set_skill
    @skill = Skill.find_by(id: params[:id])
    unless @skill
      @skill_id = params[:id]
      render :skill_not_found, status: :not_found
      nil
    end
  end

  def check_ownership
    current_user_id = params[:user_id] # TODO: Replace with current_user.id when authentication is added
    unless current_user_id && @skill.created_by.to_s == current_user_id.to_s
      redirect_to user_skills_path(@skill.created_by), alert: "You can only edit skills you created."
      nil
    end
  end

  def skill_params
    params.require(:skill).permit(:name, :description)
  end
end
