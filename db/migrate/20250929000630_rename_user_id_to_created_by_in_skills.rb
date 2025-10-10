class RenameUserIdToCreatedByInSkills < ActiveRecord::Migration[8.0]
  def change
    rename_column :skills, :user_id, :created_by
  end
end
