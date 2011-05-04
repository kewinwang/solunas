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

class RoomController < ApplicationController
  before_filter :authorize
  layout "user"
  def index
    list
    render :action => 'list'
  end

  def list
    @rooms = Room.paginate :per_page => 10,
      :conditions => ["user_id = ?",session[:user_id]],
      :page => params[:page] || 1
  end

  def show
    @room = Room.find(params[:id])
	@user_id = session[:user_id]
  end

  def new
    @room = Room.new
    if (@properties = Property.find(:all, :conditions => ["user_id = ?",session[:user_id]])).length == 0
      flash[:notice] = t(:"room.flash.add_property")
      redirect_to(:action => 'new', :controller => 'property')
    end

  end

  def create
    @room = Room.new(params[:room])
    @room.user_id = session[:user_id];
    @room.days_of_week = params[:days_of_week]
    @room.minimum_stay = Room.get_default_minimum_stay(params[:room][:minimum_stay])
    if params[:default_minimum_stay] != 0 && @room.save
      flash[:notice] = t(:"room.flash.created_ok")
      redirect_to :action => 'new', :controller => 'price'
    else
      @properties = Property.find(:all, :conditions => ["user_id = ?",session[:user_id]])
      render :action => 'new'
    end
  end

  def edit
    @room = Room.find(params[:id])
    @properties = Property.find(:all, :conditions => ["user_id = ?",session[:user_id]])
    @documents = Document.find(:all, :conditions => ["user_id = ?", session[:user_id]])
    @days_of_week = @room.days_of_week
    @prl = @room.minimum_stay
  end

  def edit_minimum_stay
    @room = Room.find(params[:id])
    @prl = @room.minimum_stay
  end

  def update
    @room = Room.find(params[:id])
    @room.days_of_week = params[:days_of_week]
    if params[:document_ids]
      @room.documents = Document.find(params[:document_ids])
    else
      @room.documents = []
    end
    if @room.update_attributes(params[:room])
      flash[:notice] = t(:"room.flash.updated_ok")
      redirect_to :action => 'edit', :id => @room

    else
      @properties = Property.find(:all, :conditions => ["user_id = ?",session[:user_id]])
      @documents = Document.find(:all, :conditions => ["user_id = ?", session[:user_id]])
      @days_of_week = @room.days_of_week
      render :action => 'edit'
    end
  end

  def new_minimum_stay
    @room = Room.find(params[:id])
    @room.minimum_stay = Room.new_minimum_stay(@room, params[:start_day], params[:start_month], params[:stop_day], params[:stop_month], params[:new_minimum_stay])

    if @room.save(perform_validation=true)
      flash[:notice] = t(:"room.flash.update_min_stay")
      redirect_to(:action => 'edit_minimum_stay', :id => @room.id)
    else
      render :action => 'edit_minimum_stay'
    end
  end

  def destroy
    Contract.delete_all(["room_id = ?", params[:id]])
    Addon.delete_all(["room_id = ?", params[:id]])
    Price.delete_all(["room_id = ?", params[:id]])
    Room.find(params[:id]).destroy
    redirect_to :action => 'list'

  end
end
