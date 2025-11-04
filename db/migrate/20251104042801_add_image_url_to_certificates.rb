class AddImageUrlToCertificates < ActiveRecord::Migration[8.0]
  def change
    add_column :certificates, :image_url, :string
  end
end
