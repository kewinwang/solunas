class AddUserColors < ActiveRecord::Migration
  def self.up
    remove_column :users, :calendar_colors
    add_column :users, :calendar_color_arrival, :string, :size => 6, :default => "08F7FF"
    add_column :users, :calendar_color_departure, :string, :size => 6, :default => "172EFF"
    add_column :users, :calendar_color_free, :string, :size => 6, :default => "05FF05"
    add_column :users, :calendar_color_blocked, :string, :size => 6, :default => "473E34"
  end

  def self.down
    add_column :users, :calendar_colors, :string
    remove_column :users, :calendar_color_arrival
    remove_column :users, :calendar_color_departure
    remove_column :users, :calendar_color_free
    remove_column :users, :calendar_color_blocked
  end
end
