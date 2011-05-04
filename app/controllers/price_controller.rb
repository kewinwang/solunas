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

class PriceController < ApplicationController
  before_filter :authorize
  layout "user"


  def index
    list
    render :action => 'list'
  end

  def list
    @prices = Price.paginate :per_page => 10,
      :conditions => ["user_id = ?",session[:user_id]],
      :page => params[:page] || 1
  end

  def show
    @price = Price.find(params[:id])
    @prl = @price.price
    @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])
  end

  def new
    @price = Price.new
    if (@rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])).length == 0
    flash[:notice] = t(:"addon.flash.add_root")
      redirect_to(:action => 'new', :controller => 'room')
    end
  end



  def create
    @price = Price.new(params[:price])
    @price.user_id = session[:user_id]
    @price.price = Price.get_default_price(params[:default_price])
    if @price.save && params[:default_price].to_i != 0
      flash[:notice] = t(:"price.flash.created_ok")
      redirect_to(:action => 'edit', :id => @price.id)
    else

      @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])
      render :action => 'new'
    end
  end

  def edit
    @price = Price.find(params[:id])
    @prl = @price.price
    @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])

  end

  def update
    @price = Price.find(params[:id])
    @price.room_id=params[:price][:room_id]
    @price.adults=params[:price][:adults]
    @price.children=params[:price][:children]
    if @price.save
      flash[:notice] = t(:"price.flash.updated_ok")
      redirect_to :action => 'list'
    else
      render :action => 'edit'
    end
  end

  def new_price
    @price = Price.find(params[:id])

    if (params[:new_price].count ";") >= 1
      arr = Array.new
      params[:new_price].split(";").each do |x|
        arr << x.split(",")
      end
    else
      arr = params[:new_price]
    end

    @price.price = Price.new_price(@price,
        params[:start_day], params[:start_month],
        params[:stop_day], params[:stop_month],
        arr)
    if @price.save!
      flash[:notice] = t(:"price.flash.schema_update")
      redirect_to(:action => 'edit', :id => @price.id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    Price.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
