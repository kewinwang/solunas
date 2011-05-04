# Global helper methods for views.
module ApplicationHelper

  # Format a float like 123.45 Eur
  def fmt_currency(amt)
    user = User.find(session[:user_id])
    sprintf(user.currency, amt)
  end

  include WillPaginate::ViewHelpers  

  def will_paginate_with_i18n(collection, options = {})
    will_paginate_without_i18n(collection,
      options.merge(:prev_label => t(:prev), :next_label => t(:next)))
  end

  alias_method_chain :will_paginate, :i18n

  def render_help
    text = 'You need help on how to set this up? <a href="http://www.solunas.org/wiki/index.php/Help_Section_Price">go here.</a>'
  end

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

