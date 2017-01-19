module PropertySpecPageHelper

  def show_property_at(addr)
    have_css("#ps-addr-title-zoom__text", :text => /#{addr}/i, :wait => 5)
  end
  
  def show_property_not_found(stuff)
    have_css(".search-not-found-results", :text => /#{stuff}/i, :wait => 5)
  end
  
end

RSpec.configure do |config|
  config.include PropertySpecPageHelper, :type => :feature
end
