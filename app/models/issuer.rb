class Issuer < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :website_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
  validates :logo_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
  validates :description, length: { maximum: 1000 }, allow_blank: true

  belongs_to :creator, class_name: "User", foreign_key: "created_by"

  has_many :certificates
end
