class AddDemoUsers < ActiveRecord::Migration
  def self.up
    user_demo = User.new
    user_demo.name = "demo"
    user_demo.password = "demo"
    user_demo.email = "demo@example.com"
    user_demo.homepage = "http://www.example.com"
    user_demo.confirmed = 1
    user_demo.save
    p "a demo account created"

    user_admin = User.new
    user_admin.name = "admin"
    user_admin.password = "admin"
    user_admin.email = "demo@example.com"
    user_admin.homepage = "http://www.example.com"
    user_admin.confirmed = 1
    user_admin.admin = 1
    user_admin.save
    p "an admin account created"
  end

  def self.down
    User.find(:first, :conditions => {:name => "demo"}).destroy
    User.find(:first, :conditions => {:name => "admin"}).destroy
  end
end
