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
  # @param p [Dict] A dict of advanced query parameters.
  #
  # @return [String] A complete SQL clauses that returns properties limited
  #         by the filters specified by the advanced query parameters.
  #
  ###########################################################################
  def get_adv_search_sql(p)
    
    # Note [1]:
    #s = "SELECT * FROM property LEFT JOIN apn on property.id = apn.propid "
    # The above causes the following error:
    # Mysql2::Error: Duplicate column name 'id': SELECT COUNT(*) FROM
    #  (SELECT * FROM property RIGHT JOIN apn on property.id = apn.propid ) AS count_table
    # at line:
    # <% @properties = Property.paginate_by_sql(sql, page: params[:page], per_page: 30)%>
    
    if !p[:apn].nil? && p[:apn].length > 0
      s = "SELECT * FROM property LEFT JOIN apn on property.id = apn.propid "
    else
      s = "SELECT * FROM property "
    end
    
    where_clause = ""
    
    if !p[:filter].nil? && p[:filter].length > 0 then
      where_clause = "(address1 LIKE \"%#{p[:filter]}%\") AND "
    end
    
    if !p[:apn].nil? && p[:apn].length > 0 then
      t = "(apn.parcel=\"#{p[:apn]}\") AND "
      where_clause = where_clause + t
    end

    if !p[:ahadid].nil? && p[:ahadid].length > 0 then
      t = "(id=\"#{p[:ahadid]}\") AND "
      where_clause = where_clause + t
    end
    
    t = get_ab_where("architect", p[:architects])
    where_clause = where_clause + t + " AND " if t != ""
    
    t = get_ab_where("builder", p[:builders])
    where_clause = where_clause + t + " AND " if t != ""

    t = get_yearbuilt_where(p)
    where_clause = where_clause + t + " AND " if t != ""

    t = get_fuzzy_architects_where(p)
    where_clause = where_clause + t + " AND " if t != ""

    t = get_ab_where("style", p[:styles])
    where_clause = where_clause + t + " AND " if t != ""

    t = get_ab_where("type", p[:types])
    where_clause = where_clause + t + " AND " if t != ""
    
    if where_clause.split(//).last(5).join == " AND " then
      where_clause = where_clause[0..-6] # get rid of trailing " AND "
    end

    s = s + "WHERE " + where_clause unless where_clause == ""

    puts "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<" + s

    return s
  end

  ###########################################################################
  # #get_yearbuilt_where

  # Given an params hash, return the SQL formatted WHERE
  # clause that limits to the years built within the specified range.
  # Does not include 'WHERE'.
  #
  # @param p [dict] Standard params hash from adv_search page.
  #        p[:yearbuilt_comparison] [String] Specifies comparison type.
  #        p[:yearbuilt_from_year] (May be nil or '' indicating to ignore.)
  #        p[:yearbuilt_to_year] (May be nil or '' indicating to ignore.)
  #
  # @return [String] WHERE logic string limiting to specific years.
  #
  ###########################################################################
  def get_yearbuilt_where (p)
    s = ""
  
    if p[:yearbuilt_comparison].nil? then
      return ""
    end
    if p[:yearbuilt_comparison].length == 0 || 
       p[:yearbuilt_from_year].length == 0 then
      return ""
    end
    
    if !p[:yearbuilt_from_year] =~ /\d+/ then
      return ""
    end 
    
    if p[:yearbuilt_comparison].upcase == "IS EQUAL TO" then
      s = "(yearbuilt = #{p[:yearbuilt_from_year]})"
      return s
    end

    if p[:yearbuilt_comparison].upcase == "IS GREATER THAN" then
      s = "(yearbuilt > #{p[:yearbuilt_from_year]})"
      return s
    end

    if p[:yearbuilt_comparison].upcase == "IS LESS THAN" then
      s = "(yearbuilt < #{p[:yearbuilt_from_year]})"
      return s
    end

    if p[:yearbuilt_comparison].upcase == "IS BETWEEN" then
      if p[:yearbuilt_to_year].nil? ||
         p[:yearbuilt_to_year].length == 0 || 
         !p[:yearbuilt_to_year] =~ /\d+/ then
        return ""
      end 

      s = "(yearbuilt >= #{p[:yearbuilt_from_year]} and yearbuilt <= #{p[:yearbuilt_to_year]})"
      return s
    end

    return ""
    
  end
  
  ###########################################################################
  # #get_architects_where

  # Given an array of names, return the SQL formatted WHERE
  # clause that limits to those names.  Does not include 'WHERE'.
  #
  # @param ar_abs [String Array] Array of names.
  #
  # @return [String] WHERE logic string limiting to specific names. If
  #         any one of the input names is "Any", then the empty
  #         string is returned which doesn't limit by name at all.
  #
  ###########################################################################
  def get_ab_where(field, ar_abs)
    # ar_abs nil
    # ar_abs 1 item
    # ar_abs 2 or more items
    # ar_abs contains "Any"

    return "" if ar_abs.nil?
    
    if ar_abs.count == 1 then
      return "" if ar_abs[0] == "Any"
      return "(#{field} = '" + ar_abs[0] + "')"
    end if
    
    s_out = "("
    ar_abs.each do |a|
      return "" if a == "Any"
      s_out = s_out + "#{field} ='" + a + "' OR "
    end
    s_out = s_out[0..-5] + ")" # Remove last " OR "
    
    return s_out
  end

  ###########################################################################
  # #get_prop_count

  # Given a full SQL string with or without a where clause, return
  # the number of records in that query.
  #
  # @param sql [String] SQL to count records returned from.
  #
  # @return [Integer] Number of records
  #
  ###########################################################################
  def get_prop_count(sql)
  
    a = sql.split("WHERE")
    if a[1].nil? 
      return Property.count
    else
      return Property.where(a[1]).count
    end
  end
 
  ###########################################################################
  # #get_fuzzy_architects_where

  # Given an array of comma separated names, return the SQL formatted WHERE
  # clause that limits to those names using LIKE. Does not include 'WHERE'.
  #
  # @param p [dict] Standard params hash from adv_search page.
  #        p[:fuzzy_architects_comparison] [String] Specifies comparison type.  
  #           "Contains Any" or "Contains All"
  #        p[:fuzzy_architects] [String] comma separated list of names
  #
  # @return [String] WHERE logic string limiting to specific names, using
  #         AND or OR depending on comparison type, and using LIKE %% to
  #         make it fuzzy.
  #
  # fred,new,ted 
  # Contains All
  #
  #   architect LIKE %fred% AND architect LIKE %new% AND ...
  #
  # Contains Any
  #
  #   architect LIKE %fred% OR architect LIKE %new% OR ...
  #
  ###########################################################################
  def get_fuzzy_architects_where(p)

    return "(TRUE)" if p[:fuzzy_architects].nil?
    
    names = p[:fuzzy_architects].split(",")
    names.each do |name|
      name = name.strip
    end
    
    if p[:fuzzy_architects_comparison] == "Contains Any"
      cmp = "OR "
    else  
      cmp = "AND"
    end
    
    s = ""    
    names.each do |name|
      s = s + "architect LIKE '%#{name}%' " + cmp + " "
    end
    
    s = "(" + s[0..-5] + ")"
    
    puts "------------------------------" + s
    
    return s
  end

end

  