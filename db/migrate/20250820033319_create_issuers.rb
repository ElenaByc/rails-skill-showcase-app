class CreateIssuers < ActiveRecord::Migration[8.0]
  def change
    create_table :issuers do |t|
      t.string :name
      t.string :website_url
      t.string :logo_url
      t.text :description

      t.timestamps
    end
  end
end
