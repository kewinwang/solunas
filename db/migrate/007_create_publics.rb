class CreatePublics < ActiveRecord::Migration
  def self.up
    create_table :publics do |t|
    end
  end

  def self.down
    drop_table :publics
  end
end
