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

class DocumentController < ApplicationController

  before_filter :authorize
  before_filter :get_user


  layout "user"
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
#   verify :method => :post, :only => [ :destroy, :create, :update ],
#   :redirect_to => { :action => :list }

  def list
    @documents = Document.paginate :page => params[:page]||1, :per_page => 1
  end

  def show
    @document = Document.find(params[:id])
  end

  def new
    @document = Document.new
  end

  def create
    @document = Document.new(params[:document])
    @document.user_id = session[:user_id]
    if @document.save
      flash[:notice] = t(:"document.flash.created_ok")
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])

    if @document.update_attributes(params[:document])
      flash[:notice] = t(:"document.flash.updated_ok")
      redirect_to :action => 'show', :id => @document
    else
      render :action => 'edit'
    end
  end

  def destroy
    Document.find(params[:id]).destroy
    redirect_to :action => 'list'
  end

  def print
  @contract = Contract.find(params[:contract_id])
  @document = Document.find(params[:id])
  render :inline => @document.rhtml

  end
end
