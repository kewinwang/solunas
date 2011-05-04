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

class CustomerController < ApplicationController

  before_filter :authorize
  layout "user"


  # Index page: List all customers
  def index
    list
    render :action => 'list'
  end

  # Search for a customer. Searchable database fields: name
  def search
  end

  # List all customers. Filter user_id
  def list
    if params[:search]
      @customers = Customer.paginate :page => params[:page]||1, :per_page => 10,
          :conditions => ["name like ? && user_id = ?","%#{params[:search]}%",
              session[:user_id]],
          :order => "created_at desc"
    else
      @customers = Customer.paginate :page => params[:page]||1, :per_page => 10,
          :conditions => ["user_id = ?",session[:user_id]],
          :order => "created_at desc"
    end
  end

  # Show one customer in detail. ID is needed.
  def show
    @customer = Customer.find(params[:id])
  end

  # Show form to create new customer
  def new
    @customer = Customer.new
  end

  # Create new customer in database
  def create
    @customer = Customer.new(params[:customer])
	@customer.user_id = session[:user_id];
    if @customer.save
      # subject and message content are under question,
      # for now they are hardcoded
      begin
	email_from    = User.find(session[:user_id]).email
	email_to      = [email_from, @customer.email]
	email_subject = "new customer created: '#{@customer.name}'"
	email_message = "new customer created: '#{@customer.name}'"
	Notifier::deliver_new_customer(
		      :from    => email_from,
		      :to      => email_to,
		      :subject => email_subject,
		      :message => email_message)
	flash[:notice] = t(:"customer.flash.created_ok")
	redirect_to :action => 'list'
      end
    else
      render :action => 'new'
    end
  end

  # Show form to edit customer. ID is needed.
  def edit
    @customer = Customer.find(params[:id])
  end

  # Update existing customer in database. Redirect to show customer
  def update
    @customer = Customer.find(params[:id])
    @customer.user_id = session[:user_id];
    if @customer.update_attributes(params[:customer])
      flash[:notice] = t(:"customer.flash.updated_ok")
      redirect_to :action => 'show', :id => @customer
    else
      render :action => 'edit'
    end
  end

  # Destroy existing customer and all contracts. Redirect to list customers
  def destroy
    Contract.delete_all(["customer_id = ?", params[:id]])
    Customer.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
