class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_default_title

  private

  def set_default_title
    @title = "AHAD" # Default title for all pages
  end
end

