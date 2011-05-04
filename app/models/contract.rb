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

#Class to get calendar data
class Contract < ActiveRecord::Base
  belongs_to :customer
  belongs_to :room
  has_and_belongs_to_many :addons
  validates_presence_of   :arrival, :departure, :adults, :children, :total
  validates_numericality_of :adults, :children, :total
  #validates_date :arrival, :departure

  #Get an 2D array of rooms each with an array of integers
  #assining free (0) or blocked(1)
  #ARRAY[room_id][day_of_month]
  #room - room objects belonging to a specific property
  #month - month to display
  #year - year to display
  #month_end - last day of month to display (31 for january)
  def self.get_calendar_data(rooms, month, year, month_end)

    @data = Array.new
    rooms.each do |room|
      @days = Array.new(month_end)
      @days.fill(0)
      calendar_date_start = year.to_i * 10000 + month.to_i * 100 + 01;
      calendar_date_end = year.to_i * 10000 + month.to_i * 100 + 31;

      #Get all contracts that are beginning AND ending in actual month
      contracts = Contract.find(:all, :conditions => ["room_id = ? && ((YEAR(departure) = ? && MONTH(departure) = ?) && (YEAR(arrival) "+
                                                                        "= ? && MONTH(arrival) = ?))",room.id, year, month, year, month])


      contracts.each do |contract|
       (contract.arrival.day-1 .. contract.departure.day-1).each do |days|
          if days==contract.arrival.day-1 && @days[days.to_i]!=3
            @days[days.to_i] = 2
          elsif days==contract.departure.day-1 && @days[days.to_i]!=2
            @days[days.to_i] = 3
          else
            @days[days.to_i] = 1
          end
        end
      end

      #Get all contracts that are ONLY beginning in actual month
      contracts = Contract.find(:all, :conditions => ["room_id = ? && ((YEAR(departure) != ? || MONTH(departure) != ?) && YEAR(arrival) "+
                                                                        "= ? && MONTH(arrival) = ?)",room.id, year, month, year, month])


      contracts.each do |contract|
       (contract.arrival.day-1 .. month_end-1).each do |days|
          if days==contract.arrival.day-1 && @days[days.to_i]!=3
            @days[days.to_i] = 2
          else
            @days[days.to_i] = 1
          end
        end
      end

      #Get all contracts that are ONLY ending in actual month
      contracts = Contract.find(:all, :conditions => ["room_id = ? && ((YEAR(departure) = ? && MONTH(departure) = ?) && (YEAR(arrival) "+
                                                                        "!= ? || MONTH(arrival) != ?))",room.id, year, month, year, month])


      contracts.each do |contract|
       (0 .. contract.departure.day-1).each do |days|
          if days==contract.departure.day-1 && @days[days.to_i]!=2
            @days[days.to_i] = 3
          else
            @days[days.to_i] = 1
          end
        end
      end

      #Check,if a contract is over full month
      contracts = Contract.count(:conditions => ["room_id = ? && (arrival < ? && "+
                                                                        "departure > ?)",room.id, calendar_date_start, calendar_date_end])
      if contracts > 0

         (0 .. month_end-1).each do |days|
          @days[days.to_i] = 1
        end

      end
      room_id = room.id.to_i
      @data[room_id] = @days
    end
    return @data
  end

  #Get an 2D array of integers assining free (0) or blocked(1)
  #ARRAY[month][day]
  #room - ONE room object
  #year - year to display
  def self.get_calendar_data_by_year(room, year)

    @data = Array.new

     (1 .. 12).each do |month|
      months = Array.new(31)
      months.fill(0)
      @data[month] = months
    end

    calendar_date_start = ::Date.new(year.to_i,1,1)
    calendar_date_end = ::Date.new(year.to_i,12,31)

    #Get all contracts that are beginning AND ending in actual year
    contracts = Contract.find(:all, 
      :conditions => ["room_id = ? && YEAR(departure) = ? && YEAR(arrival) = ?",room.id, year, year])

    contracts.each do |contract|
      contract.arrival.upto(contract.departure){|date|
        if date==contract.arrival && @data[date.month][date.day]!=3
          @data[date.month][date.day] = 2
        elsif date==contract.departure && @data[date.month][date.day]!=2
          @data[date.month][date.day] = 3
        else
          @data[date.month][date.day] = 1
        end
      }
    end

    #Get all contracts that are ONLY beginning in actual year
    contracts = Contract.find(:all,
      :conditions => ["room_id = ? && YEAR(departure) != ? && YEAR(arrival) = ?",room.id, year, year])

    contracts.each do |contract|
      contract.arrival.upto(calendar_date_end){|date|
        if date==contract.arrival && @data[date.month][date.day]!=3
          @data[date.month][date.day] = 2
        else
          @data[date.month][date.day] = 1
        end
      }

    end

    #Get all contracts that are ONLY ending in actual year
    contracts = Contract.find(:all,
      :conditions => ["room_id = ? && YEAR(departure) = ? && YEAR(arrival) != ?",room.id, year, year])


    contracts.each do |contract|
      calendar_date_start.upto(contract.departure){|date|
        if date==contract.departure && @data[date.month][date.day]!=2
          @data[date.month][date.day] = 3
        else
          @data[date.month][date.day] = 1
        end
      }

    end

    #Check,if a contract is over full year
    contracts = Contract.count(:conditions => ["room_id = ? && (arrival < ? && "+
                                                                        "departure > ?)",room.id, calendar_date_start, calendar_date_end])
    if contracts > 0

      calendar_date_start.upto(calendar_date_end){|date|
        @data[date.month][date.day] = 1}


    end



    return @data
  end


  def validate
    if self.departure == nil
      errors.add("Departure")
    elsif self.arrival == nil
      errors.add("Arrival")
    else
      if (self.departure < self.arrival || self.arrival < ::Date.today || self.departure < ::Date.today || self.departure == self.arrival)
        errors.add("Arrival Date")
        errors.add("Departure Date")
      end
      if Contract.count(:conditions => ["room_id = '?' && ((arrival < ? AND ? < departure) || (arrival < ? AND ? < departure) || (? < arrival  && ? > departure))",self.room_id, self.arrival, self.arrival, self.departure, self.departure, self.arrival, self.departure]) >= 1
        errors.add("Time period is blocked")
      end
    end


  end




end
