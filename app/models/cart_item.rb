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

class CartItem 
		
		attr_reader :room, :total, :arrival, :departure, :adults, :children, :addons, :item_id
		
		#Set the Cart Line Item
		#Addons are serialized and stored as objects
		def initialize(item_id, addon, room, total, arrival, departure, adults, children)
				@item_id = item_id
				@room = room
				@total = total
				@arrival = arrival
				@departure = departure
				@adults = adults
				@children = children
				@addons = addon
				
		end
end