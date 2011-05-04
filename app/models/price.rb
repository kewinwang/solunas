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

class Price < ActiveRecord::Base
  belongs_to :room
  serialize :price
  validates_presence_of  :adults, :children, :price
  validates_numericality_of :adults, :children, :integer_only => true, :within => 0 .. 10
  #return an 2D array of default price
  #Array[month][day_of_month] = defalt
  def validate
    if adults.to_i == 0
      errors.add(:adults,": You need at least one Adult")
    end
    if :price.to_i == 0
    errors.add("Please fill in a valid default price")
    end
  end
  def self.get_default_price(default)
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

  #Set a new price in the price array
  def self.new_price(price, start_day, start_month, stop_day, stop_month, new_price)
    prl = price.price
    convert_start = ::Time.local(*ParseDate.parsedate("2000-" + start_month + "-" + start_day))
    convert_stop = ::Time.local(*ParseDate.parsedate("2000-" + stop_month + "-" + stop_day))
    counter = convert_start

    while counter <= convert_stop do
      prl["#{counter.month}"]["#{counter.mday}"] = new_price
      counter = counter + 1.day
    end
    return prl
  end



end
