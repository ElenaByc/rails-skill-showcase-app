class Certificate < ApplicationRecord
  belongs_to :user
  belongs_to :issuer

  has_many :certificate_skills
  has_many :skills, through: :certificate_skills

  validates :name, presence: true
  validates :issued_on, presence: true
  validates :verification_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }
end
