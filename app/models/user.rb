class User < ApplicationRecord
  has_secure_password

  has_many :certificates
  has_many :skills, through: :certificates

  has_many :created_skills, class_name: "Skill", foreign_key: "created_by"
  has_many :created_issuers, class_name: "Issuer", foreign_key: "created_by"

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  # Returns all unique skills associated with the user's certificates
  def unique_skills
    skills.distinct
  end

  # Returns certificates that include a specific skill
  def certificates_by_skill(skill_name)
    certificates.joins(:skills).where(skills: { name: skill_name }).distinct
  end

  # Returns certificates issued by a specific issuer
  def certificates_by_issuer(issuer_name)
    certificates.joins(:issuer).where(issuers: { name: issuer_name }).distinct
  end

  # Returns certificates completed after a given date
  def certificates_after(date)
    certificates.where("completion_date >= ?", date)
  end

  # Returns certificates completed before a given date
  def certificates_before(date)
    certificates.where("completion_date <= ?", date)
  end

  # Returns certificates within a date range (either or both ends optional)
  def certificates_between(start_date: nil, end_date: nil)
    scope = certificates
    scope = scope.where("completion_date >= ?", start_date) if start_date.present?
    scope = scope.where("completion_date <= ?", end_date) if end_date.present?
    scope
  end
end
