class SkillsController < ApplicationController
  before_action :require_login, only: [ :index, :new, :create, :edit, :update, :destroy ]
  before_action :set_skill, only: [ :show, :edit, :update, :destroy ]
  before_action :check_ownership, only: [ :edit, :update, :destroy ]

  def show
    @user = User.find(@skill.created_by)
    @certificates = @skill.certificates.includes(:user, :issuer)
  end

  def new
    @skill = Skill.new
    @user_id = session[:user_id] # Get user ID from session
  end

  def create
    @skill = Skill.new(skill_params)
    @skill.created_by = session[:user_id] # Get user ID from session

    if @skill.save
      redirect_to skills_path, notice: "Skill was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @skill.update(skill_params)
      redirect_to skills_path, notice: "Skill was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @skill.destroy
    redirect_to skills_path, notice: "Skill was successfully deleted."
  end

  def index
    @user = User.find(session[:user_id])
    unless @user
      @user_id = session[:user_id]
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
    current_user_id = session[:user_id]
    unless current_user_id && @skill.created_by.to_s == current_user_id.to_s
      redirect_to skills_path, alert: "You can only edit skills you created."
      nil
    end
  end

  def skill_params
    params.require(:skill).permit(:name, :description)
  end
end
