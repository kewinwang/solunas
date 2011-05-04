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

class PublicController < ApplicationController


  layout "public"
  before_filter :find_cart
  before_filter :find_user

  def index
  end
  def show_calendar
    @month = params[:month] ||= ::Time.now.month
    @year = params[:year] ||= ::Time.now.year
    @month_var = month_vars(@month.to_i, @year)
    @property = Property.find(params[:property_id])
    @properties = Property.find(:all, :conditions => ["user_id = ?",@user_id])
    @rooms = Room.find(:all, :conditions => ["user_id = ? && property_id = ?",@user_id, params[:property_id]])

    @calendar = Contract.get_calendar_data(@rooms, @month, @year, @month_var["end"].to_i)
    render(:layout => false)
  end

  def choose_calendar
    @properties = Property.find(:all, :conditions => ["user_id = ?",@user_id])
    render(:layout => false)
  end

  def choose_calendar_by_year
    @rooms = Room.find(:all, :conditions => ["user_id = ?",@user_id])
    render(:layout => false)
  end

  def show_calendar_by_year
    @year = params[:year] || ::Date.today.year
    @room = Room.find(:first, :conditions => ["user_id = ? && id = ?",@user_id, params[:room_id]])
    @calendar = Contract.get_calendar_data_by_year(@room, @year)
    render(:layout => false)
  end

  def calendar
    if params[:property_id]
      @property_id = params[:property_id]
    else
      @property_id = Property.find(:first, :conditions => ["user_id = ?",@user_id]).id
    end
    @month = params[:month] ||= ::Time.now.month
    @year = params[:year] ||= ::Time.now.year
    if params[:raw]
      render(:layout => false)
    end
  end



  def calendar_by_year
    @room = Room.find(:first, :conditions => ["user_id = ? && id = ?",@user_id, params[:room_id]])
    @year = params[:year] ||= ::Time.now.year
  end

  def show_form
    @max_a = params[:adults]
    if !@errors
      @errors =[]
    end

  end

  def show_rooms

    @errors = Public.test_form(params[:arrival],params[:departure],params[:adults],params[:children],@user.datestring)


    if @errors.empty?

      @arrival = ::DateTime.strptime(params[:arrival], @user.datestring)
      @departure = ::DateTime.strptime(params[:departure], @user.datestring)
      @free_rooms = Public.get_free_rooms(@user, @arrival, @departure, params[:adults], params[:children])

      if @free_rooms == false
        redirect_to(:action=> 'show_form')
        flash[:notice] = 'Choose correct Arrival and Departure dates'.t
      elsif @free_rooms.length == 0
        redirect_to(:action=> 'show_form')
        flash[:notice] = 'No rooms available'.t
      else
        @adults = params[:adults]
        @children = params[:children]
      end
    else
      render(:action => "show_form")
    end

  end

  def add_to_cart
    @room = Room.find(params[:room_id])
    @arrival = ::DateTime.strptime(params[:arrival], @user.datestring)
    @departure = ::DateTime.strptime(params[:departure], @user.datestring)
    @addons = Addon.find(:all, :conditions => ["user_id = ? && room_id = ? && force_cart = ?", @user_id, params[:room_id], true])
    if @cart.add_line(@addons, @room, params[:total], @arrival, @departure, params[:adults], params[:children]) == false
      flash[:notice] = 'Room already in cart.'
    end
    redirect_to(:action=> 'display_cart')
  end

  def display_cart

  end

  def empty_cart
    @cart.empty!
    redirect_to(:action=> 'display_cart')
  end

  def delete_cart_item
    @cart.change_total(@cart.items[params[:cart_item_id].to_i].total)
    @cart.items.delete_at(params[:cart_item_id].to_i)
    flash[:notice] = 'Cart item deleted.'
    redirect_to(:action=> 'display_cart')
  end

  def checkout
    @items = @cart.items
    if @items.empty?
      redirect_to(:action=> 'display_cart')
    end
  end

  def save_booking


    @items = @cart.items
    @customer = Customer.new(params[:customer])
    @customer.user_id = @user_id
    if @customer.save
      @items.each do |item|
        @contract = Contract.new(params[:contract])
        @contract.room_id = item.room.id
        @contract.total = item.total
        @contract.arrival = item.arrival
        @contract.departure = item.departure
        @contract.adults = item.adults
        @contract.children = item.children
        @contract.customer_id = @customer.id
        @contract.pending = 1
        @contract.unconfirmed = 1
        @contract.user_id = @user_id
        @contract.addons << item.addons
        if @contract.save
          @cart.empty!
        end
      end
    else
      #flash[:notice] = 'Please fill out the complete form.'
      render(:action=> 'checkout')
    end



  end

  private

  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end

  def find_user
    if params[:user_id]
      session[:puID] = params[:user_id]
    end
    @user_id = session[:puID]
    @user = User.find(@user_id)
    Locale.set @user.language
  end
end
