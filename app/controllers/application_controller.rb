class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  def hello
    render html: "<div id='testid'>hello, world!</div>"
  end
end
