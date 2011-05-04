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

class Public < ActiveRecord::Base


  #Get an array of free rooms
  def self.get_free_rooms(user, arrival, departure, adults, children)
    #Convert arrival and departure in date object
    convert_arrival = arrival
    convert_departure = departure

    if (departure < arrival || arrival < ::Date.today || departure < ::Date.today)
      return false
    end

    data = Array.new << 0
    rooms = Array.new
    user_id = user.id

    #get all blocked rooms
    blocked_rooms = Contract.find(:all, :conditions => ["user_id = ? && (arrival < ? AND ? < departure) || (arrival < ? AND ? < departure) || (? < arrival && ? > departure)",user_id, arrival, arrival, departure, departure, arrival, departure])

    blocked_rooms.each do |room|
      data << room.room_id
    end

    #Filter I => blocked rooms

    all_rooms = Room.find(:all, :conditions => ["user_id = ? && id not in (?)", user_id, data])



    #Calculate Price and return room array
    all_rooms.each do |room|
      dow = room.days_of_week
      ms = room.minimum_stay

      #Filter II => day of week and minimum stay
      if  dow["#{convert_arrival.wday}"].to_i == 1 && (convert_departure - convert_arrival).to_i >= ms["#{convert_arrival.month}"]["#{convert_arrival.mday}"].to_i

        #Filter III => adults and children
        price_available = Price.find_by_sql(["select * from prices where room_id = ? && adults - (? + if((? - children)>0,(?-children),0)) >= 0 ",room.id, adults.to_i,children.to_i,children.to_i])
        if !price_available.empty?
          #push room to array
          rooms << {"room", room, "price", get_price(user, room, arrival, departure, adults, children)}
        end

      end

    end
    return rooms
  end



  def self.get_price(user, room, arrival, departure, adults, children)

    user_id = user.id
    prices_available = Price.find_by_sql(["select * from prices where room_id = ? && adults - (? + if((? - children)>0,(?-children),0)) >= 0 ",room.id, adults.to_i,children.to_i,children.to_i])
    price = prices_available[0].price

    convert_arrival = arrival
    convert_departure = departure
    days_to_stay = (convert_departure - convert_arrival).to_i
    counter = convert_arrival
    addprice = 0
    while counter < convert_departure do

      check_price = price["#{counter.month}"]["#{counter.mday}"]

      #Check if price is array, something like 1,3,50;4,10,40
      if check_price.class == Array

        check_price.each do |array_price|
          if (array_price[0].to_i <= days_to_stay && array_price[1].to_i >= days_to_stay)
            addprice = addprice.to_i + array_price[2].to_i
          end
        end
      else
        addprice = addprice.to_i + check_price.to_i
      end
      counter = counter + 1
    end

    #Add prices of addons
    addons = Addon.find(:all, :conditions => ["user_id = ? && room_id = ? && force_cart = ?", user_id, room.id, true])
    onetime = 1
    per_person = 1
    addons.each do |addon|
      if !addon.onetime?
        onetime =  days_to_stay.to_i
      end
      if addon.per_person?
        per_person = (adults.to_i + children.to_i)
      end
      addprice = addprice.to_i + (per_person * onetime * addon.price).to_i
      onetime = per_person = 1
    end

    #Return price including force addons, and room price depending on duration
    return addprice

  end

  def self.test_form(arrival,departure,adults,children,datestring)
    errors =[]
    if arrival.blank?
      errors << "Arrival can't be blank"
    else
      begin
        arrival_test = ::DateTime.strptime(arrival, datestring)
      rescue Exception => err
        errors << "Arrival: " + err.message
      end
    end
    if departure.blank?
      errors << "Departure can't be blank"
    else
      begin
        departure_test = ::DateTime.strptime(departure, datestring)
      rescue Exception => err
        errors << "Departure: " + err.message
      end
    end

    if adults.to_i + children.to_i == 0
      errors << "Choose at least one person"
    end


    return errors
  end



end
