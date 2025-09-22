class User < ApplicationRecord
  has_secure_password

  has_many :certificates
  has_many :skills, through: :certificates

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  def unique_skills
    skills.distinct
  end

  # Returns all certificates that include a specific skill
  def certificates_by_skill(skill_name)
    certificates.joins(:skills).where(skills: { name: skill_name }).distinct
  end
end
