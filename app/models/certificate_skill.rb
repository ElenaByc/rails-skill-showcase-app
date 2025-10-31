class CertificateSkill < ApplicationRecord
  belongs_to :certificate
  belongs_to :skill

  validates :certificate_id, uniqueness: { scope: :skill_id }
  validates :skill_id, presence: true
end
