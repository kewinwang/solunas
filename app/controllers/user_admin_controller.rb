class UserAdminController < ApplicationController

  before_filter :authorize
  layout "user"

  def index
    #@total_orders   = Order.count
    #@pending_orders = Order.count_pending

    @user = User.find(session[:user_id])
    @contract_count = Contract.count(:conditions => ["user_id = ?",session[:user_id]])

    session[:my_locale] = I18n.locale

    if session[:admin]==1
      @admin = session[:admin]
      redirect_to(:controller => "admin", :action => "index")
    end

  end

end
