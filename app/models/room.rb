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

class Room < ActiveRecord::Base
  belongs_to :property
  belongs_to :user
  has_many :cart_items
  has_one :price
  has_many :addons
  has_many :contracts
  has_and_belongs_to_many :documents
  serialize :days_of_week
  serialize :minimum_stay
  validates_presence_of :name,:days_of_week,:minimum_stay
  #validates_numericality_of :default_miniumum_stay, [:only_integer => true]
  #Returns an array of minimum stay
  #Array [month][day_of_month] = default
  def self.get_default_minimum_stay(default)

    if default.to_i == 0
    return nil
    else
      months = Hash.new
      month_data = Hash.new

       (1 .. 12).each do |month|

        days = Hash.new
         (1 .. 31).each do |day|

          days["#{day}"] = default

        end
        months["#{month}"] = days
      end
      return months

    end
  end

  #Set the minimum stay for a period of the year
  def self.new_minimum_stay(room, start_day, start_month, stop_day, stop_month, new_minimum_stay)
    prl = room.minimum_stay
    convert_start = ::Time.local(*ParseDate.parsedate("2000-" + start_month + "-" + start_day))
    convert_stop = ::Time.local(*ParseDate.parsedate("2000-" + stop_month + "-" + stop_day))
    counter = convert_start

    while counter <= convert_stop do
      prl["#{counter.month}"]["#{counter.mday}"] = new_minimum_stay
      counter = counter + 1.day
    end
    return prl
  end
end
