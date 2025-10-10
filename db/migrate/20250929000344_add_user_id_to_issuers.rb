class AddUserIdToIssuers < ActiveRecord::Migration[8.0]
  def change
    add_reference :issuers, :user, null: false, foreign_key: true
  end
end
