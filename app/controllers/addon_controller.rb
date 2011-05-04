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

class AddonController < ApplicationController

  before_filter :authorize
  layout "user"

  def index
    list
    render :action => 'list'
  end

  def list
    @addons = Addon.paginate :page => params[:page]||1, :per_page => 10,
      :conditions => ["user_id = ?",session[:user_id]]
  end

  def show
    @addon = Addon.find(params[:id])
  end

  def new
    @addon = Addon.new
    if (@rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])).length == 0
    flash[:notice] = t(:"addon.flash.add_room")
      redirect_to(:action => 'new', :controller => 'room')
    end
  end

  def create
    @addon = Addon.new(params[:addon])
    @addon.user_id = session[:user_id]
    if @addon.save
      flash[:notice] = t(:"addon.flash.created_ok")
      redirect_to :action => 'list'
    else
      @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])
      render :action => 'new'
    end
  end

  def edit
    @addon = Addon.find(params[:id])
    @rooms = Room.find(:all, :conditions => ["user_id = ?", session[:user_id]])
  end

  def update
    @addon = Addon.find(params[:id])
    @addon.user_id = session[:user_id]
    if @addon.update_attributes(params[:addon])
      flash[:notice] = t(:"addon.flash.updated_ok")
      redirect_to :action => 'show', :id => @addon
    else
      @rooms = Room.find(:all, :conditions => ["user_id = ?", session[:user_id]])
      render :action => 'edit'
    end
  end

  def destroy
    Addon.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
