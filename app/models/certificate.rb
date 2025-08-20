class Certificate < ApplicationRecord
  belongs_to :user
  belongs_to :issuer

  has_many :certificate_skills
  has_many :skills, through: :certificate_skills
end
