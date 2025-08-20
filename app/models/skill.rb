class Skill < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 1000 }, allow_blank: true

  has_many :certificate_skills
  has_many :certificates, through: :certificate_skills
end
