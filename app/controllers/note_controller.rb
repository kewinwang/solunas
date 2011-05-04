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

class NoteController < ApplicationController

before_filter :authorize
layout "user"

  def index
    list
    render :action => 'list'
  end

  def list
    @customer = Customer.find(params[:customer_id])
    @notes = Note.paginate :page => params[:page]||1, :per_page => 1,
      :conditions => ["user_id = ? && customer_id = ?",session[:user_id],params[:customer_id]]
  end

  def show
    @note = Note.find(params[:id])
  end

  def new
    @note = Note.new
    @customer = Customer.find(params[:customer_id])
  end

  def create
    @note = Note.new(params[:note])
    @note.customer_id = params[:customer_id]
    @note.user_id = session[:user_id]
    if @note.save
      flash[:notice] = t(:"note.flash.created_ok")
      redirect_to(:action => 'show', :controller => 'customer', :id => params[:customer_id])
    else
      render :action => 'new'
    end
  end

  def edit
    @note = Note.find(params[:id])
  end

  def update
    @note = Note.find(params[:id])
    if @note.update_attributes(params[:note])
      flash[:notice] = t(:"note.flash.updated_ok")
      redirect_to :action => 'show', :id => @note
    else
      render :action => 'edit'
    end
  end

  def destroy
    Note.find(params[:id]).destroy
    redirect_to(:action => 'list', :customer_id => params[:customer_id])
  end
end
