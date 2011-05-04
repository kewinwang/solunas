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

class ContractController < ApplicationController

  before_filter :authorize
  before_filter :get_user
  layout "user"


  # Index page: List all contracts
  def index
    list
    render :action => 'list'
  end

  def search
  end

  # List all contracts
  def list
    if params[:search]
      @contracts = Contract.paginate :page => params[:page]||1, :per_page => 10,
	:conditions => ["user_id = ? && id = ?",session[:user_id], params[:search]],
	:order => "created_at desc"
    elsif params[:customer_id]
      @contracts = Contract.paginate :page => params[:page]||1, :per_page => 10,
	:conditions => ["user_id = ? && customer_id = ?",session[:user_id], params[:customer_id]],
	:order => "created_at desc"
      @customer_id = params[:customer_id]

    else
      @contracts = Contract.paginate :page => params[:page]||1, :per_page => 10,
        :conditions => ["user_id = ?",session[:user_id]],
        :order => "created_at desc"
    end
  end

  # List all pending contracts
  def list_pending
    @contracts = Contract.paginate :page => params[:page]||1, :per_page => 10,
      :conditions => ["user_id = ? && pending = 1", session[:user_id]],
      :order => "created_at desc"
  end

  # List all unconfirmed contracts
  def list_unconfirmed
    @contracts = Contract.paginate :page => params[:page]||1, :per_page => 10,
      :conditions => ["user_id = ? && unconfirmed = 1",session[:user_id]],
      :order => "created_at desc"
  end


  # Show one contract in detail. ID is needed
  def show
    @contract = Contract.find(params[:id])
    @addons = @contract.addons

  end

  # Create new contract. If no customer is selected, redirect to customer page
  def new
    @contract = Contract.new
    if(params[:id])
      @customers = Customer.find(:first, :conditions => ["user_id = ? and id = ?",session[:user_id], params[:id]])
    else
      flash[:notice] = t(:"contract.flash.choose_customer")
      redirect_to(:controller => "customer", :action => "search")
    end
    @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])
  end

  # Create new contract and save into database
  def create
    @contract = Contract.new(params[:contract])
    @contract.user_id = session[:user_id]
    @contract.customer_id = params[:customer_id]
    @contract.pending = 1

    begin
      @contract.save!
      flash[:notice] = t(:"contract.flash.created_ok")
      email_from    = User.find(session[:user_id]).email
      email_to      = [email_from, @contract.customer.email]
      email_subject = "New Contract"
      email_message = "A new contract was made from '#{@contract.customer.name}'"
      Notifier::deliver_document(
		:from    => email_from,
		:to      => email_to,
		:subject => email_subject,
		:message => email_message)
      redirect_to :action => 'list'
    rescue
      @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])
      @customers = Customer.find(:first, :conditions => ["user_id = ? and id = ?",session[:user_id], @contract.customer_id])
      render(:action => 'new')
    end
  end

  # Edit existing contracts
  def edit
    @contract = Contract.find(params[:id])
    @addons = @addons = Addon.find(:all, :conditions => ["user_id = ? && room_id = ?", session[:user_id], @contract.room_id])
    @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])
  end

  # Update existing contracts in database
  def update
    @contract = Contract.find(params[:id])
    @contract.user_id = session[:user_id]
    @contract.customer_id = params[:customer_id]
    if params[:addon_ids]
      @contract.addons = Addon.find(params[:addon_ids])
    else
      @contract.addons = []
    end

    if @contract.update_attributes(params[:contract])
      flash[:notice] = t(:"contract.flash.updated_ok")
      redirect_to :action => 'show', :id => @contract
    else

       @addons = @addons = Addon.find(:all, :conditions => ["user_id = ? && room_id = ?", session[:user_id], @contract.room_id])
       @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])
      render :action => 'edit'
    end
  end

  # Confirm a contract.
  def confirm
    @contract = Contract.find(params[:id])
    @contract.pending = 0
    if @contract.save
      flash[:notice] = t(:"contract.flash.confirmed_ok")
      redirect_to :action => 'list_pending'
    else
      flash[:notice] = t(:"contract.flash.confirmed_nok", :bold_open => "<b>", :bold_close => "</b>")
      redirect_to :action => 'list_pending'
    end
  end

  def confirm_public
    @contract = Contract.find(params[:id])
    @contract.unconfirmed = 0
    if @contract.update
      flash[:notice] = t(:"contract.flash.confirmed_ok")
      redirect_to :action => 'list_unconfirmed'
    else
      flash[:notice] = t(:"contract.flash.confirmed_nok", :bold_open => "<b>", :bold_close => "</b>")
      redirect_to :action => 'list_unconfirmed'
    end
  end


  # Destroy existing contract
  def destroy
    Contract.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  # Choose month and year to show overwiew of availability
  def choose_calendar
    @properties = Property.find(:all, :conditions => ["user_id = ?",session[:user_id]])
    render(:layout => false)
  end

  def choose_calendar_by_year
    @rooms = Room.find(:all, :conditions => ["user_id = ?",session[:user_id]])
    render(:layout => false)
  end

  def show_calendar
    begin
      year        = params[:year]  || Time.now.year
      month       = params[:month] || Time.now.month
      property_id = params[:property_id]
      user        = User.find(session[:user_id])
      property    = user.properties.find(property_id)
      year        = year.to_i
      month       = month.to_i
      arrival     = Time.gm(year, month)
      departure   = arrival.advance(:year => 10)
      arrival     = arrival.months_ago(120)
      rooms       = []
      property.rooms.sort_by(&:name).each do |room|
        rooms << [room, room.contracts.find(:all,
                    :conditions => ["arrival >= ? OR departure <= ? AND departure >= ?",
                                     arrival, departure, arrival])]
      end
      render :partial => "results_calendar_by_month",
                  :locals => {:user => user, :rooms => rooms, :year => year, :month => month}
    rescue Exception => e
      logger.error("A critical error: '#{e.message}'")
      render :partial => "/error",
                :locals => {:error => e.message}
    end
  end

  def show_calendar_by_year
    year = params[:year] || Time.now.year
    user = User.find(session[:user_id])
    room = user.rooms.find(params[:room_id])
    year = year.to_i
    arrival   = DateTime.civil(year)
    departure = DateTime.civil(year + 10)
    arrival   = DateTime.civil(year - 10)
    contracts = room.contracts.find(:all,
                  :conditions => ["arrival >= ? OR departure <= ? AND departure >= ?",
                                   arrival, departure, arrival])
    render :partial => "results_calendar_by_year", 
              :locals => {:user => user, :contracts => contracts, :year => year}
  end

  def calendar
  end

  def send_document
    @contract = Contract.find(params[:contract_id])
    @document = Document.find(params[:id])
    email_from    = User.find(session[:user_id]).email
    email_to      = @contract.customer.email
    email_subject = @document.name
    email_message = render_to_string(:inline => @document.rhtml)
    Notifier::deliver_document(
		:from    => email_from,
		:to      => email_to,
		:subject => email_subject,
		:message => email_message)
    flash[:notice] = t(:"contract.flash.doc_mailed")
    redirect_to :action => 'show', :id => params[:contract_id]
  end








end
