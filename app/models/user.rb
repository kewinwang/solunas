#************************************************************************/
#* SOLUNAS BOOKING ENGINE                                               */
#* ======================                                               */
#*                                                                      */
#* Copyright (c) 2006 by Marc Isemann                                   */
#* http://sourceforge.net/projects/solunas                              */
#*                                                                      */
#* This program is free software. You can redistribute it and/or modify */
#* it under the terms of the GNU General Public License as published by */
#* the Free Software Foundation; either version 2 of the License.       */
#************************************************************************/

require "digest/sha1"

class User < ActiveRecord::Base
  has_many :rooms
  has_many :properties

  #has_and_belongs_to_many :roles
  serialize :calendar_symbols

  attr_accessor :password
  attr_accessible :name, :password

  validates_uniqueness_of :name
  validates_presence_of   :name, :homepage, :email
  validates_format_of :email,
    :with =>  %r{^[a-zA-Z0-9@\.]*}i,
    :message => "Email was an invalid format"
  validates_format_of :homepage,
    :with => %r{^(http|https)://[a-z0-9]+([-.]{1}[a-z0-9]+)*.[a-z]{2,5}(([0-9]{1,5})?/.*)?$}ix, 
    :message => "Homepage has an invalid format"
  validates_format_of :calendar_color_arrival,
    :with =>  %r/^[a-z0-9]{6}/i,
    :message => "The calendar color for 'arrival' is invalid"
  validates_format_of :calendar_color_departure,
    :with =>  %r/^[a-z0-9]{6}/i,
    :message => "The calendar color for 'departure' is invalid"
  validates_format_of :calendar_color_free,
    :with =>  %r/^[a-z0-9]{6}/i,
    :message => "The calendar color for 'free' is invalid"
  validates_format_of :calendar_color_blocked,
    :with =>  %r/^[a-z0-9]{6}/i,
    :message => "The calendar color for 'blocked' is invalid"

  # Return the User with the given name and
  # plain-text password
  def self.login(name, password)
    hashed_password = hash_password(password || "")
    find(:first,
         :conditions => ["name = ? and hashed_password = ? and confirmed = 1",
    name, hashed_password])
  end

  # Log in if the name and password (after hashing)
  # match the database, or if the name matches
  # an entry in the database with no password
  def try_to_login
    User.login(self.name, self.password)
  end

  def try_to_find
    User.find(:first, :conditions => ["email = ? && name = ?", self.email, self.name])
  end

  # When a new User is created, it initially has a
  # plain-text password. We convert this to an SHA1 hash
  # before saving the user in the database.
  def before_create
    self.hashed_password = User.hash_password(self.password)
  end



  # Clear out the plain-text password once we've
  # saved this row. This stops it being made available
  # in the session
  def after_create
    @password = nil
  end

  private

  def self.hash_password(password)
    Digest::SHA1.hexdigest(password)
  end



end

