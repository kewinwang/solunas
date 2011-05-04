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

class UserController < ApplicationController
  before_filter :authorize
  layout "user"

  LANG_FILES = Dir[Rails.root.join('config', 'locales', '*.{yml}')].map do |file|
    file = File.basename(file, ".yml")
  end 

  def index
    list
    render :action => 'list'
  end

  def list
    @users = User.paginate :page => params[:page]||1, :per_page => 10
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new

    @calendar_symbols = {}
    @calendar_colors = {}
  end

  def create
    @user = User.new(params[:user])

    if @user.save
      flash[:notice] = t(:"user_admin.flash.created_ok")
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(session[:user_id])

    @calendar_symbols = @user.calendar_symbols || []
    @calendar_color_arrival   = @user.calendar_color_arrival
    @calendar_color_departure = @user.calendar_color_departure
    @calendar_color_free      = @user.calendar_color_free
    @calendar_color_blocked   = @user.calendar_color_blocked
  end

  def update
    @user = User.find(params[:id])
    if !params[:password].empty?
      @user.hashed_password = User.hash_password(params[:password])
    end
    @user.homepage = params[:user][:homepage]
    @user.email = params[:user][:email]

    if params[:user][:language]
      if !params[:user][:language].empty?
        if LANG_FILES.include?(params[:user][:language])
          @user.language = params[:user][:language]
        end
      end
    end

    if session[:admin] == 0
      @user.datestring = params[:user][:datestring]
      @user.currency = params[:user][:currency]
      @user.header = params[:user][:header]
      @user.footer = params[:user][:footer]
      @user.creditcard = params[:user][:creditcard]
      @user.calendar_symbols = params[:calendar_symbols]
      @user.calendar_color_arrival = params[:user][:calendar_color_arrival]
      @user.calendar_color_departure = params[:user][:calendar_color_departure]
      @user.calendar_color_free = params[:user][:calendar_color_free]
      @user.calendar_color_blocked = params[:user][:calendar_color_blocked]
    end

    if @user.save #_attributes(params[:user])
      flash[:notice] = t(:"user_admin.flash.updated_ok")
      redirect_to :action => 'edit', :id => @user
    else
      render :action => 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
