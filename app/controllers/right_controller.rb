class RightController < ApplicationController
  layout "admin"

  # You must be logged in to use all functions except #login
  #before_filter :authorize

  def add_right_for_admin

    if !Right.find_by_name(params[:right_controller] + " " + params[:right_action])
      role = Role.find_by_name("Administrator")
      right = Right.create(:name => params[:right_controller] + " " + params[:right_action], :controller => params[:right_controller], :action => params[:right_action])
      role.rights << right
    end
    flash[:notice] = 'Admin Right was successfully updated.'
    redirect_to :action => params[:right_action], :controller => params[:right_controller]
  end

  def add_right_for_user

    if !Right.find_by_name(params[:right_controller] + " " + params[:right_action])
      role = Role.find_by_name("User")
      right = Right.create(:name => params[:right_controller] + " " + params[:right_action], :controller => params[:right_controller], :action => params[:right_action])
      role.rights << right
    end
    flash[:notice] = 'User Right was successfully updated.'
    redirect_to :action => params[:right_action], :controller => params[:right_controller]
  end

end
