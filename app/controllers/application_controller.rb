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

class ApplicationController < ActionController::Base

#   require 'date'

#   model :cart
#   model :cart_item

  before_filter :set_controller_action, :set_locale

  rescue_from ActiveRecord::RecordNotFound, :with => :exception_handler
  rescue_from ::ActionController::UnknownAction, :with => :exception_handler
  rescue_from ::ActionController::RoutingError, :with => :exception_handler
  rescue_from ::ActionController::UnknownController, :with => :exception_handler

  def local_request?
    return false if RAILS_ENV == 'production'
  end

  private
  def exception_handler(e)
    render :template => "/_error", :locals => {:error => e.message}
  end

  public
  def set_controller_action
    @right_controller = self.class.controller_path
    @right_action = action_name
  end


  def set_locale
    if session[:user_id]
      default_language = :en
      user_language = User.find(session[:user_id]).language
      if user_language && !user_language.empty?
	I18n.locale = user_language
      else
	I18n.locale = default_language
      end
    end
  end

  # The #authorize method is used as a <tt>before_hook</tt> in
  # controllers that contain administration actions. If the
  # session does not contain a valid user, the method
  # redirects to the LoginController.login.
  def authorize                            #:doc:
    unless session[:user_id]
      flash[:notice] = t(:"app.flash.please_login")
      redirect_to(:controller => "login", :action => "login")
    end
    #Set rights and roles -> ToDo
    #user = User.find(session[:user_id])
    #unless user.roles.detect{|role|
    #    role.rights.detect{|right|
    #      right.action == action_name && right.controller == self.class.controller_path
    #      #right.controller == self.class.controller_path
    #    }
    #  }
    #  flash[:notice] = "You are not authorized to view the page you requested."
    #
    #  request.env["HTTP_REFERRER"] ? (redirect_to :back) : redirect_to(:controller => "login", :action => "login")
    #end
  end

  def authorize_as_admin
    unless session[:user_id] && session[:admin] == 1
      flash[:notice] = t(:"app.flash.please_login")
      redirect_to(:controller => "login", :action => "login")
    end
  end

  def redirect_to_index(message = nil)
    flash[:notice] = message if message
    redirect_to(:action => 'index')
  end

  def get_user
    @user = User.find(session[:user_id])
  end

  public

  def month_vars(month, year="2000")

    case month
    when 1
      data = {"name" => "January", "end" => "31"}
    when 2
      if (year.to_i % 4 == 0)
        data = {"name" => "February", "end" => "29"}
      else
        data = {"name" => "February", "end" => "28"}
      end
    when 3
      data = {"name" => "March", "end" => "31"}
    when 4
      data = {"name" => "April", "end" => "30"}
    when 5
      data = {"name" => "May", "end" => "31"}
    when 6
      data = {"name" => "June", "end" => "30"}
    when 7
      data = {"name" => "July", "end" => "31"}
    when 8
      data = {"name" => "August", "end" => "31"}
    when 9
      data = {"name" => "September", "end" => "30"}
    when 10
      data = {"name" => "October", "end" => "31"}
    when 11
      data = {"name" => "November", "end" => "30"}
    when 12
      data = {"name" => "December", "end" => "31"}
    end
  end




end
