class UpdateMstUsers < ActiveRecord::Migration
  def self.up
    add_column :mst_users, :crypted_password,          :string, :limit => 40
    add_column :mst_users, :salt,                      :string, :limit => 40
    add_column :mst_users, :remember_token,            :string
    add_column :mst_users, :remember_token_expires_at, :datetime
  end

  def self.down
  end
end
