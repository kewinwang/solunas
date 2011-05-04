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
require "digest/sha1"

class RegisterController < ApplicationController


  layout "register"

  #Confirmation page for newly registered users
  def register_confirmation
  end

  #register a new user
  def register_user

    if request.get?
      @user = User.new
      @user_count = User.count
    else
      @user = User.new(params[:user])
      @user.confirmed = "0"
      @user.email = params[:user][:email]
      @user.homepage = params[:user][:homepage]
      @user.premium = params[:user][:premium]

      if @user.save
        Notifier::deliver_signup_confirmation_mail(@user)
        redirect_to(:action => 'register_confirmation')
      end
    end
  end

  def confirm_user
    @user = User.find(:first, :conditions => ["id = ? && confirmed = '0'", params[:valid_key]])
    @user.confirmed = "1"
    @user.datestring = "%d.%m.%Y"
    @user.header = "</head><body>"
    @user.currency = "%0.2f Eur"
    @user.language = "en-US"
    @user.calendar_symbols = ["A","D","F","B"]
    @user.calendar_colors = ["green","green","green","#c0c0c0"]
    if @user.update
      Notifier::deliver_signup_thanks(@user)
      flash[:notice] = "You are confirmed - please login".t
      redirect_to(:action => "login", :controller => "login")
    else
      flash[:notice] = "You are not confirmed".t
      redirect_to(:action => "register_user")
    end
  end

end