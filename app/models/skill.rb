class Skill < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 1000 }, allow_blank: true
end
