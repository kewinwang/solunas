class AdminController < ApplicationController

  layout "admin"

  # You must be logged in to use all functions except #login
  before_filter :authorize_as_admin


  # Add a new user to the database.
  def add_user
    if request.get?
      @user = User.new
    else
      @user = User.new(params[:user])
      @user.admin = params[:user][:admin]
      @user.datestring = "%d.%m.%Y"
      @user.header = "</head><body>"
      @user.currency = "%0.2f Eur"
      @user.confirmed = "1"
      @user.language = "en-US"
      @user.calendar_symbols = ["A","D","F","B"]
      @user.calendar_colors = ["green","green","green","#c0c0c0"]
      @user.homepage = params[:user][:homepage]
      @user.email = params[:user][:email]
      if @user.save
        redirect_to_index("User #{@user.name} created")
      end
    end
  end


  # Delete the user with the given ID from the database.
  # The model raises an exception if we attempt to delete
  # the last user.
  def delete_user
    id = params[:id]
    if user = User.find(id)
      begin
        if user.confirmed == 1
          user.destroy
          flash[:notice] = t(:"admin.flash.user_deleted", :username => user.name)
          redirect_to(:action => :list_users)
        else
          user.destroy
          flash[:notice] = t(:"admin.flash.user_deleted", :username => user.name)
          redirect_to(:action => :list_users_to_confirm)
        end
      rescue
        flash[:notice] = t(:"admin.cannot_delete")
      end
    end

  end

  # List all the users.
  def list_users
    @order = params[:order] || "created_at DESC"
    @order = "updated_at ASC" if @order == session[:list_users_order]
    @all_users = User.paginate :page => params[:page]||1, 
                               :per_page => 10,
                               :conditions => ["confirmed = 1"],
                               :order => @order
    session[:list_users_order] = @order
  end

  # List all unconfirmed users
  def list_users_to_confirm
    @all_users = User.paginate :page => params[:page]||1, 
                               :per_page => 10,
                               :conditions => ["confirmed = 0"]
  end

  #confirm a newly registered user
  def confirm_user
    @user = User.find(params[:id])
    @user.confirmed = 1
    @user.datestring = "%d.%m.%Y"
    @user.header = "</head><body>"
    @user.currency = "%0.2f Eur"
    @user.language = "en-US"

    if @user.update
      Notifier::deliver_signup_thanks(@user)
      flash[:notice] = t(:"admin.flash.user_confirmed")
      redirect_to(:action => "list_users_to_confirm")
    else
      flash[:notice] = t(:"admin.flash.user_not_confirmed")
      redirect_to(:action => "list_users_to_confirm")
    end
  end

  # Show default administation page
  def index
    @user = User.find(session[:user_id])
  end

  # Update Globalize localisation entries
  def lang_db_update
    locale_update
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:password] and !params[:password].empty?
      @user.hashed_password = User.hash_password(params[:password])
    end
    @user.homepage = params[:user][:homepage]
    @user.email = params[:user][:email]
    @user.language = params[:user][:language]


    if @user.save #_attributes(params[:user])
      flash[:notice] = t(:"admin.user_success_update")
      redirect_to :action => 'edit', :id => @user
    else
      render :action => 'edit'
    end
  end
  def list_users_export
  @user = User.find(:all)
  end



end
