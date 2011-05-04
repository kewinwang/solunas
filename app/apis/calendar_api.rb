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

class CalendarApi < ActionWebService::API::Base
  api_method :show_calendar_by_room,
  :expects => [{:property_id => :int}, {:year =>:int}, {:month =>:int}, {:language => :string}, {:username => :string}, {:password => :string}],
  :returns => [:string]
  api_method :show_calendar_by_year,
  :expects => [{:room_id => :int}, {:year =>:int}, {:language => :string}, {:username => :string}, {:password => :string}],
  :returns => [:string]
  api_method :get_calendar_array_by_month,
  :expects => [{:room_id => :int}, {:year =>:int}, {:month =>:int}, {:language => :string}, {:username => :string}, {:password => :string}],
  :returns => [[:int]]
  api_method :get_free_rooms,
  :expects => [{:arrival => :string}, {:departure =>:string}, {:adults =>:int}, {:children =>:int}, {:language => :string}, {:username => :string}, {:password => :string}],
  :returns => [[FreeRoom]]
  api_method :save_reservation,
  :expects => [{:arrival => :string},
  {:departure =>:string},
  {:adults =>:int},
  {:children =>:int},
  {:name =>:string},
  {:street =>:string},
  {:zip =>:string},
  {:city =>:string},
  {:country =>:string},
  {:email =>:string},
  {:telefone =>:string},
  {:cc_number =>:string},
  {:cc_expire_date =>:string},
  {:cc_cvv =>:string},
  {:room_id =>:int},
  {:total =>:float},
  {:username => :string},
  {:password => :string}],
  :returns => [:int]
  api_method :get_property_list,
  :expects => [{:username => :string}, {:password => :string}],
  :returns => [[PropertyList]]
  api_method :get_id,
  :expects => [{:username => :string}, {:password => :string}],
  :returns => [:int]


end
