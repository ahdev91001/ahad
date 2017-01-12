module UtilGlobals

  def log_paranoia_check(msg) 
    logger.warn "[PC] " + msg
    logger.warn "[PC] => At: " + caller(1).first
    logger.warn "[PC] => Called from: " + caller(2).first
  end

end