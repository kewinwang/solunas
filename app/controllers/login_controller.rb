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

class LoginController < ApplicationController

  layout "login"

  # You must be logged in to use all functions except #login
  before_filter :authorize, :except => [:login, :new_password]

  def index
    render(:action => login)
  end

  # Display the login form and wait for user to
  # enter a name and password. We then validate
  # these, adding the user object to the session
  # if they authorize.
  def login
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.new(params[:user])
      logged_in_user = @user.try_to_login

      if logged_in_user
        session[:user_id] = logged_in_user.id
        session[:admin] = logged_in_user.admin
#         Locale.set logged_in_user.language
        redirect_to(:action => "index", :controller => "user_admin")
      else
        flash[:notice] =t(:"login.flash.invalid_login")
      end
    end
  end

  def new_password
    if request.get?
      session[:user_id] = nil
      @user = User.new
    else
      @user = User.find_by_email_and_name(params[:user][:email], params[:user][:name])

      if @user
        password = rand(999999).to_s
        @user.hashed_password = User.hash_password(password)
        @user.update
        Notifier::deliver_new_password(@user, password)
        flash[:notice] = t(:"login.flash.password_emailed")
        redirect_to(:action => "login", :controller => "login")
      else
        flash[:notice] = t(:"login.flash.invalid_email")
      end
    end
  end

  # Log out by clearing the user entry in the session. We then
  # redirect to the #login action.
  def logout
    session[:user_id] = nil
    flash[:notice] = t(:"login.flash.logged_out")
    redirect_to(:action => "login")
  end



end
