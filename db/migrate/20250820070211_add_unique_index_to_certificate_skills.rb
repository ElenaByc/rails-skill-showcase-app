class AddUniqueIndexToCertificateSkills < ActiveRecord::Migration[8.0]
  def change
    add_index :certificate_skills, [:certificate_id, :skill_id], unique: true
  end
end
