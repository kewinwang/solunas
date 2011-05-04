class OptimisticLocking < ActiveRecord::Migration
  def self.up
    add_column :customers, :count, :integer
    add_column :customers, :lock_version, :integer, :default => 0
    add_column :rooms, :count, :integer
    add_column :rooms, :lock_version, :integer, :default => 0
    add_column :contracts, :count, :integer
    add_column :contracts, :lock_version, :integer, :default => 0
    add_column :properties, :count, :integer
    add_column :properties, :lock_version, :integer, :default => 0
    add_column :addons, :count, :integer
    add_column :addons, :lock_version, :integer, :default => 0
    add_column :notes, :count, :integer
    add_column :notes, :lock_version, :integer, :default => 0
    add_column :documents, :count, :integer
    add_column :documents, :lock_version, :integer, :default => 0
    add_column :prices, :count, :integer
    add_column :prices, :lock_version, :integer, :default => 0
    add_column :users, :count, :integer
    add_column :users, :lock_version, :integer, :default => 0
    add_column :rights, :count, :integer
    add_column :rights, :lock_version, :integer, :default => 0
  end

  def self.down
    remove_column :customers, :count
    remove_column :customers, :lock_version
    remove_column :rooms, :count
    remove_column :rooms, :lock_version
    remove_column :contracts, :count
    remove_column :contracts, :lock_version
    remove_column :properties, :count
    remove_column :properties, :lock_version
    remove_column :addons, :count
    remove_column :addons, :lock_version
    remove_column :notes, :count
    remove_column :notes, :lock_version
    remove_column :documents, :count
    remove_column :documents, :lock_version
    remove_column :prices, :count
    remove_column :prices, :lock_version
    remove_column :users, :count
    remove_column :users, :lock_version
    remove_column :rights, :count
    remove_column :rights, :lock_version
  end
end
