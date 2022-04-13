class AddStatusToFriendship < ActiveRecord::Migration[7.0]
  def change
    add_column :friendships, :status, :boolean
  end
end
