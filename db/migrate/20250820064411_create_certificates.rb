class CreateCertificates < ActiveRecord::Migration[8.0]
  def change
    create_table :certificates do |t|
      t.string :name
      t.date :issued_on
      t.string :verification_url
      t.references :user, null: false, foreign_key: true
      t.references :issuer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
