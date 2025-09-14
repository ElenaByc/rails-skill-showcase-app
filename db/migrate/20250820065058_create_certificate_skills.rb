class CreateCertificateSkills < ActiveRecord::Migration[8.0]
  def change
    create_table :certificate_skills do |t|
      t.references :certificate, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
