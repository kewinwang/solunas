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

class BackendController < ApplicationController
    wsdl_service_name 'Backend'
    web_service_api CalendarApi
    web_service_scaffold :invoke

  def show_calendar_by_room(property_id, year, month, language, username, password)
    if user=User.login(username ,password)
#      Locale.set language
      @year = year
      @month = month
      @month_var = month_vars(@month.to_i, @year)
      @room = Room.find(:all, :conditions => ["user_id = ? && property_id = ?",user.id, property_id])
      @calendar = Contract.get_calendar_data(@room, @month, @year, @month_var["end"].to_i)
      content = "<style type='text/css'>
                 <!--
                 #calendar_av {
                 width: 15px;
                 background-color: " + user.calendar_colors["2"] + ";
                 color: white;
                 font-weight: bold;
                 padding: 0px;
                 margin: 0px;
				 text-align: center;
                 }

                 #calendar_not_av {
                 width: 15px;
                 background-color: " + user.calendar_colors["3"] + ";
                 color: white;
                 font-weight: bold;
                 padding: 0px;
                 margin: 0px;
				 text-align: center;
                 }
                 #calendar {
                 width: 15px;
                 padding: 0px;
                 margin: 0px;
                 }
                 #calendar_tr {
                 font-family: Verdana, Arial, Helvetica, sans-serif;
                 font-size: 11px;
                 }
				 #calendar_arrival {
                 width: 11px;
                 background-color: " + user.calendar_colors["0"] + ";
                 color: white;
                 font-weight: bold;
                 padding: 0px;
                 margin: 0px;
                 border-right: 4px solid " + user.calendar_colors["3"] + ";
                 }
                 #calendar_departure {
                 width: 11px;
                 background-color: " + user.calendar_colors["1"] + ";
                 color: white;
                 font-weight: bold;
                 padding: 0px;
                 margin: 0px;
                 border-left: 4px solid " + user.calendar_colors["3"] + ";
}
                  -->
                 </style><table id='table_calendar'><tr id='calendar_tr'><td nowrap>" + "Room".t + "</td>"


       (1 .. @month_var["end"].to_i).each do |days|

        content = content + "<td id='calendar' align='center'>" + days.to_s + "</td>"

      end
      content = content + "</tr>"

      @room.each do |room|
        content = content + "<tr id='calendar_tr'><td>" + room.name + "</td>"

        @calendar[room.id].each_with_index do |days, i|

          date = ::Date.new(@year.to_i,@month.to_i,i+1).strftime(user.datestring)

          if (days == 1 || ::Date.new(@year.to_i,@month.to_i,i+1) < ::DateTime.now-(1))
            content = content + "<td id='calendar_not_av' align='center' title='" + date + "'>" + user.calendar_symbols["3"]
          elsif days == 2
            content = content + "<td id='calendar_arrival' align='center' title='" + date + "'>" + user.calendar_symbols["0"]
          elsif days == 3
            content = content + "<td id='calendar_departure' align='center' title='" + date + "'>" + user.calendar_symbols["1"]
          else
            content = content + "<td id='calendar_av' align='center' title='" + date + "'>" + user.calendar_symbols["2"]
          end
          content = content + "</td>"
        end
        content = content + "</tr>"
      end
      content = content + "</table>"

      render(:text => content)
    else
      render(:text => "Not logged in" + user.inspect)
    end
  end

  def show_calendar_by_year(room_id, year, language, username,password)
    if user=User.login(username ,password)
#      Locale.set language
      @year = year
      @room = Room.find(:first, :conditions => ["user_id = ? && id = ?",user.id, room_id])
      @calendar = Contract.get_calendar_data_by_year(@room, @year)
      content = "<style type='text/css'>
                 <!--
                 #calendar_av {
                 width: 15px;
                 background-color: " + user.calendar_colors["2"] + ";
                 color: white;
                 font-weight: bold;
                 padding: 0px;
                 margin: 0px;
				 text-align: center;
                 }

                 #calendar_not_av {
                 width: 15px;
                 background-color: " + user.calendar_colors["3"] + ";
                 color: white;
                 font-weight: bold;
                 padding: 0px;
                 margin: 0px;
				 text-align: center;
                 }
                 #calendar {
                 width: 15px;
                 padding: 0px;
                 margin: 0px;
                 }
                 #calendar_tr {
                 font-family: Verdana, Arial, Helvetica, sans-serif;
                 font-size: 11px;
                 }
				 #calendar_arrival {
                 width: 11px;
                 background-color: " + user.calendar_colors["0"] + ";
                 color: white;
                 font-weight: bold;
                 padding: 0px;
                 margin: 0px;
                 border-right: 4px solid " + user.calendar_colors["3"] + ";
                 }
                 #calendar_departure {
                 width: 11px;
                 background-color: " + user.calendar_colors["1"] + ";
                 color: white;
                 font-weight: bold;
                 padding: 0px;
                 margin: 0px;
                 border-left: 4px solid " + user.calendar_colors["3"] + ";
                 }
                  -->
                 </style><table id='table_calendar'><tr id='calendar_tr'><td width='100'><b>" + "Month".t + "</b></td>"


       (1 .. 31).each do |days|

        content = content + "<td id='calendar' align='center'>" + days.to_s + "</td>"

      end
      content = content + "</tr></table>"

       (1 .. 12).each do |x|
        @month = month_vars(x, @year)
        content = content + "<table id='table_calendar'><tr id='calendar_tr'><td width='100'><b>" + @month["name"].t + "</b></td>"
         (1 .. @month["end"].to_i).each do |y|

          date = ::Date.new(@year.to_i,x,y).strftime(user.datestring)

          if (@calendar[x][y] == 1 || ::Date.new(@year.to_i,x,y) < ::DateTime.now-(1))
            content = content + "<td id='calendar_not_av' align='center' title='" + date + "'>" + user.calendar_symbols["3"]
          elsif @calendar[x][y] == 2
            content = content + "<td id='calendar_arrival' align='center' title='" + date + "'>" + user.calendar_symbols["0"]
          elsif @calendar[x][y] == 3
            content = content + "<td id='calendar_departure' align='center' title='" + date + "'>" + user.calendar_symbols["1"]
          else
            content = content + "<td id='calendar_av' align='center' title='" + date + "'>" + user.calendar_symbols["2"]
          end
          content = content + "</td>"
        end
        content = content + "</tr> </table>"
      end
      render(:text => content)
    else
      render(:text => "Not logged in" + user.inspect)
    end
  end

  def get_calendar_array_by_month(room_id, year, month, language, username, password)
    if user=User.login(username ,password)
#      Locale.set language
      @year = year
      @month = month
      @month_var = month_vars(@month.to_i, @year)
      @room = Room.find(:all, :conditions => ["user_id = ? && id = ?",user.id, room_id])
      @calendar = Contract.get_calendar_data(@room, @month, @year, @month_var["end"].to_i)
      @calendar[room_id]
    else
      render(:text => "Not logged in" + user.inspect)
    end
  end

  def get_free_rooms(arrival,departure, adults, children, language, username, password)
    if user=User.login(username ,password)
#      Locale.set language
      room_array = Array.new
      #convert_arrival = Date.strptime(arrival, user.datestring)
      #convert_departure = Date.strptime(departure, user.datestring)
      _y, _m, _d = arrival.split(".").reverse().map{ |e| e.to_i }
      convert_arrival = Date.civil(_y, _m, _d)
      _y, _m, _d = departure.split(".").reverse().map{ |e| e.to_i }
      convert_departure = Date.civil(_y, _m, _d)
      free_rooms = Public.get_free_rooms(user, convert_arrival, convert_departure, adults, children)
      free_rooms.each do |rooms|
        freeroom = FreeRoom.new
        freeroom.id = rooms["room"].id
        freeroom.name = rooms["room"].name
        freeroom.property = rooms["room"].property.name
        freeroom.price = rooms["price"]
        #freeroom.addons = rooms["room"].addons
        room_array << freeroom
      end
      room_array
    else
      render(:text => "Not logged in" + user.inspect)
    end
  end

  def save_reservation(arrival,departure,adults,children,name,street,zip,city,country,email,telefone,cc_number,cc_expire_date,cc_cvv,room_id,total,username,password)
    if user=User.login(username ,password)
      #Save customer
      customer = Customer.new()
      customer.name = name
      customer.street = street
      customer.zip = zip
      customer.city = city
      customer.country = country
      customer.email = email
      customer.telefone = telefone
      customer.user_id = user.id
      customer.save
      #Save contract
      contract = Contract.new()
      contract.total = total
      _y, _m, _d = arrival.split(".").reverse().map{ |e| e.to_i }
      contract.arrival = Date.civil(_y, _m, _d)
      _y, _m, _d = departure.split(".").reverse().map{ |e| e.to_i }
      contract.departure = Date.civil(_y, _m, _d)
      contract.adults = adults
      contract.children = children
      contract.cc_number = cc_number
      contract.cc_expire_date = cc_expire_date
      contract.cc_cvv = cc_cvv
      contract.room_id = room_id
      contract.customer_id = customer.id
      contract.user_id = user.id
      contract.pending = 1
      contract.unconfirmed = 1
      contract.addons << Addon.find(:all, :conditions => ["user_id = ? && room_id = ? && force_cart = ?", user.id, room_id, true])
      if contract.save && customer.id
        return 1
      else
        return 0
      end
    else
      render(:text => "Not logged in" + user.inspect)
    end
  end

  def get_property_list(username,password)
    if user=User.login(username ,password)
      property_array = Array.new
      properties = Property.find(:all, :conditions => ["user_id = ?", user.id])
      properties.each do |property|
        list = PropertyList.new
        list.id = property.id
        list.name = property.name
        property_array << list
      end
      return property_array
    else
      render(:text => "Not logged in" + user.inspect)
    end
  end

  def get_id(username,password)
    if user=User.login(username ,password)
      return user.id
    end
  end



end
