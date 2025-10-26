class Skill < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :created_by }
  validates :description, length: { maximum: 1000 }, allow_blank: true

  has_many :certificate_skills
  has_many :certificates, through: :certificate_skills

  belongs_to :creator, class_name: "User", foreign_key: "created_by"
end
