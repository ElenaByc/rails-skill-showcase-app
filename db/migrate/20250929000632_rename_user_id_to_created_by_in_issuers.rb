class RenameUserIdToCreatedByInIssuers < ActiveRecord::Migration[8.0]
  def change
    rename_column :issuers, :user_id, :created_by
  end
end
