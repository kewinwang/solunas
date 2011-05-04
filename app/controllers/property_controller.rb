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

class PropertyController < ApplicationController
  before_filter :authorize
  layout "user"

  def index
    list
    render :action => 'list'
  end

  def list
    if Property.count(:conditions => ["user_id = ?", session[:user_id]]) == 0
      @properties = []
    else
      @properties = Property.paginate :per_page => 10,
	:conditions => ["user_id = ?", session[:user_id]],
	:page => params[:page] || 1
    end
  end

  def show
    @property = Property.find(params[:id])
    @user_id = session[:user_id]
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(params[:property])
    @property.user_id = session[:user_id]
    if @property.save
      flash[:notice] = t(:"property.flash.created_ok")
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find(params[:id])
    if @property.update_attributes(params[:property])
      flash[:notice] = t(:"property.flash.updated_ok")
      redirect_to :action => 'show', :id => @property
    else
      render :action => 'edit'
    end
  end

  def destroy
    if Room.count(:conditions => ["property_id = ?", params[:id]]) > 0
      flash[:notice] = t(:"property.flash.delete_rooms")
      redirect_to :action => 'list'
    else
      Property.find(params[:id]).destroy
      redirect_to :action => 'list'
    end

  end

  def public_code
    @user_id = session[:user_id]
    @property = Property.find(:first, :conditions => ["user_id = ?", session[:user_id]])
  end
end
