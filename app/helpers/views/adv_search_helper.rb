#############################################################################
# Views::AdvSearchHelper
#
# Since 12/18/2018 Derek Carlson
#############################################################################
module Views::AdvSearchHelper

  ###########################################################################
  # #get_adv_search_sql

  # Given a params dict of advanced search query filters, return the
  # associated SQL to select just those properties specified.
  #
  # @param params [Dict] A dict of advanced query parameters.
  #
  # @return [String] A complete SQL clauses that returns properties limited
  #         by the filters specified by the advanced query parameters.
  #
  ###########################################################################
  def get_adv_search_sql(p)
    s = "SELECT * FROM property "
    where_clause = ""
    
    if !p[:filter].nil? then
      where_clause = "(address1 LIKE \"%#{p[:filter]}%\") AND "
    end
    
    t = get_ab_where("architect", p[:architects])
    where_clause = where_clause + t + " AND " if t != ""
    
    t = get_ab_where("builder", p[:builders])
    
    where_clause = where_clause + t + " AND " if t != ""
    
    if where_clause.split(//).last(5).join == " AND " then
      where_clause = where_clause[0..-6] # get rid of trailing " AND "
    end

    s = s + "WHERE " + where_clause unless where_clause == ""

    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" + s

    return s
  end

  ###########################################################################
  # #get_architects_where

  # Given an array of architect names, return the SQL formatted WHERE
  # clause that limits to those names.  Does not include 'WHERE'.
  #
  # @param ar_architects [String Array] Architect names.
  #
  # @return [String] WHERE logic string limiting to specific architects. If
  #         any one of the input architect names is "Any", then the empty
  #         string is returned which doesn't limit by architect at all.
  #
  ###########################################################################
  def get_ab_where(field, ar_abs)
    # ar_architects nil
    # ar_architects 1 item
    # ar_architects 2 or more items
    # ar_architects contains "Any"

    return "" if ar_abs.nil?
    
    if ar_abs.count == 1 then
      return"" if ar_abs[0] == "Any"
      return "(#{field} = '" + ar_abs[0] + "')"
    end if
    
    s_out = "("
    ar_abs.each do |a|
      return"" if a == "Any"
      s_out = s_out + "#{field} ='" + a + "' OR "
    end
    s_out = s_out[0..-5] + ")" # Remove last " OR "
    
    return s_out
  end

end

