module PublicHelper
  def fmt_currency_public(amt)
    user = User.find(session[:puID])
    sprintf(user.currency, amt)
  end

  def max_adult_select
    max=(0..Price.maximum(:adults, :conditions => ["user_id = ?",session[:puID]])).to_a
    default = params[:adults].to_s ||= "0"
    ofs = options_for_select(max, default)
    select_tag "adults", ofs

  end
  def max_children_select

    max=(0..Price.maximum(:children, :conditions => ["user_id = ?",session[:puID]])).to_a
    ofs = options_for_select(max, "0")
    select_tag "children", ofs

  end
end
