module PropertiesHelper
  
  def normalize_address(addr)
    addr.upcase!
    # remove leading and trailing whitespace
    addr = addr.match(/\s*([^\s].*[\S])\s*/).captures[0]
    # remove multiple whitespace chars between words
    addr.gsub!(/(\S)\s\s+(\S)/,'\1 \2')
    # turn lone tabs into spaces
    addr.gsub!(/\t/, ' ')
    # remove . at end of ST., AVE., etc.
    addr.gsub!(/\.$/, '')
    # we return ST, AVE, BLVD, etc., so convert the variants
    # into this standard
    addr.gsub!(/STREET$/, 'ST') 
    addr.gsub!(/AVENUE$/, 'AVE') 
    addr.gsub!(/BOULEVARD$/, 'BLVD') 
    addr
  end
  
end
