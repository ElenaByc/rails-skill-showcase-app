class Certificate < ApplicationRecord
  belongs_to :user
  belongs_to :issuer

  has_many :certificate_skills, dependent: :destroy
  has_many :skills, through: :certificate_skills

  validate :certificate_name_presence
  validate :issued_on_presence
  validate :has_at_least_one_skill
  validates :verification_url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true }

  private

  def certificate_name_presence
    if name.blank?
      errors.add(:base, "Certificate name can't be blank")
    end
  end

  def issued_on_presence
    if issued_on.blank?
      errors.add(:base, "Issue date can't be blank")
    end
  end

  def has_at_least_one_skill
    if skill_ids.blank? || skill_ids.reject(&:blank?).empty?
      errors.add(:base, "Certificate must have at least one skill")
    end
  end
end
