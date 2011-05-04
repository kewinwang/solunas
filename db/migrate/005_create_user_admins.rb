class CreateUserAdmins < ActiveRecord::Migration
  def self.up
    create_table :user_admins do |t|
      # t.column :name, :string
    end
  end

  def self.down
    drop_table :user_admins
  end
end
