#############################################################################
# PropertiesHelper
#
# Since 1/20/17 Derek Carlson <carlson.derek@gmail.com>
#############################################################################
module PropertiesHelper
  include UtilGlobals

  ###########################################################################
  # #normalize_address

  # Convert common ways to type addresses (St or St. or Street, etc.) into
  # the consistent way used in the database (address1 field).
  #
  # @param addr [String] the raw address
  #
  # @return [String] the address converted into a format used in the database
  #
  # Handles multiple whitespace before, after, and between words, 
  # including tabs.
  #
  # Example: '1099 Mt   Lowe Drive' => '1099 MT LOWE DR'  
  # Example: '419 West Palm St.' => '419 W PALM ST'
  #
  # Misc notes:
  #
  #   * Mt Curve and Mt Lowe (turn Mount to Mt) 
  #   * E, N, W, S Altadena Drive (and a lot others): Turn EAST -> E, etc.  
  #   * Way (all *Way's end in Way, except 796 Fontanet Wy)
  #   * Inconsistent data in the database as of 1/11/17 DDC: South and Palmyra 
  #     (both are names of the street and lack a trailing designation such as
  #     St or Rd, etc.)
  #
  ###########################################################################
  def normalize_address(addr)
    #### paranoia checks ####
    if ( !(addr).is_a?(String) || addr.length == 0 ) 
      log_paranoia_check("Bad parameter: addr (" + addr.to_s + "). Should " +
        "be a String and non-zero length.")
      return addr # not sure, maybe should be ""
    end
    #### end paranoia checks ####
    
    addr.upcase!
    # remove leading and trailing whitespace
    addr = addr.match(/\s*([^\s].*[\S])\s*/).captures[0]
    # remove multiple whitespace chars between words
    addr.gsub!(/(\S)\s\s+(\S)/,'\1 \2')
    # turn lone tabs into spaces
    addr.gsub!(/\t/, ' ')
    # remove . at end of ST., AVE., etc.
    addr.gsub!(/\.$/, '')

    street_name_xfms = {
      'ST': "STREET$",
      'AVE': "AVENUE$",
      'BLVD': "BOULEVARD$",
      'RD': "ROAD$",
      'DR': "DRIVE$",
      'PL': "PLACE$",
      'LN': "LANE$",
      'CIR': "CIRCLE$",
      'TER': "TERRACE$",
      'CT': "COURT$",      
      'TR': "TRAIL$",      
      'WAY': "WY$",  # yes, this one is opposite the others      
      ' N ': " NORTH ", ' S ': " SOUTH ", ' E ': " EAST ", ' W ': " WEST ",
      ' MT ': " MOUNT "
    }

    street_name_xfms.each do |k, v|
      addr.gsub!(/#{v}/, k.to_s) 
    end

    addr
  end
  
end
