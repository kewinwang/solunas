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

#Class to hande the cart at checkout process. It stores all reservations and force addons
class Cart
		
		attr_reader :items
		attr_reader :total_price
		
		#Initialize the cart 
		def initialize
				empty!
		end
		
		#Add a new line to the card - also the force addons are included.
		#The total amount is calculated from room price and addons
		def add_line(addons, room, total, arrival, departure, adults, children)
				#item_check = @items.find {|i| i.room.id == room.id and i.arrival  arrival}
				#if !item_check
                if !check_doubles(room, arrival, departure)
				item = CartItem.new(@index, addons, room, total, arrival, departure, adults, children)
				@items << item
				@total_price += total.to_f
				@index = @index + 1
				return true
				else
				return false
				end
		end
		
		def check_doubles(room, arrival, departure)
		item_check = @items.find {|i| i.room.id == room.id and \
		((i.arrival <= arrival and i.departure >= arrival) or \
		(i.arrival <= departure and i.departure >= departure) or \
		(arrival <= i.arrival and departure >= i.departure))}
		end
		
		
		#Empty the cart 
		def empty!
				@items = []
				@total_price = 0.00
				@index = 0
		end
		
		def change_total(amount)
		@total_price = @total_price - amount.to_f
		end
end