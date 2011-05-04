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

class Addon < ActiveRecord::Base
  belongs_to :room
  has_and_belongs_to_many :contracts
  validates_presence_of  :name, :price
  validates_numericality_of :price

  #get an array of addon IDs
  def self.get_addons(addons)
    addon_array = Array.new
    addons.to_a.each do |addon|
      addon_array << addon[0]
    end
    return addon_array
  end
end
