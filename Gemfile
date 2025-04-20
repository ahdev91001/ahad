source 'https://rubygems.org'
# REQUIRED for basic features
# -----------------------------------------------------------------------------
#ruby "2.5.5"
# ruby "2.5.9"
# ruby "2.6.10"
# ruby "2.7.8"
# ruby "3.0.7"
ruby '3.2.8'

gem 'rails', '~> 6.1.7.7'
gem 'activesupport', '6.1.7.7'    # Force same version as Rails
gem 'mysql2', '~> 0.5.5'          # Connects to remote db
gem 'puma', '~> 5.6'              # The webserver, essential for serving the app
gem 'bootstrap-sass', '3.3.7'     # Used only in user model for login
gem 'bcrypt',         '3.1.12'    # Used only in user model (user.rb) for login
gem 'kaminari',       '1.2.2'     # Used in advanced search (replaced will_paginate)
gem 'responders',     '~> 3.0'    # Standardizes HTTP responses
gem 'sassc-rails',    '~> 2.0'    # Support for SASS stylesheets; used everywhere
gem 'uglifier',       '3.0.0'     # Only used in production, but necessary for performance
gem 'jquery-rails',   '4.1.1'     # Used by application.js; provides jquery support
gem 'turbolinks',     '5.0.1'     # Used by application.js; speeds up page loads
gem 'redcarpet',      '~> 3.0.0'  # Markdown parser; used by application_helper.rb
gem 'draper',         '4.0.0'     # Used by decorators
gem 'fuzzy-string-match'          # Used by controllers/helpers for address matching
gem "cocoon"                      # Used by application.js; handles 'nested forms'
gem 'nokogiri',       '1.15.7'    # XML thing?
gem 'guard',          '2.13.0'    # Testing thing?
gem 'prawn'                       # PDF writer

# NOT REQUIRED for basic features:
# -----------------------------------------------------------------------------
# duplicate, commented out by DJR, 8/21/2019
# gem 'bootstrap-sass', '3.3.7'
# gem 'prawn-table'                    # support for drawing tables in PDFs
# gem 'geocoder'                       # finds address coordinates
# gem 'google_maps_service'
# gem 'normalize-scss', '~> 4.0', '>= 4.0.3'
# gem 'activemodel-serializers-xml'
# gem 'jbuilder',     '2.4.1'   # Generates JSON responses easily
# gem 'coffee-rails', '4.2.1'   # Seems totally unncessary
# gem 'bootstrap-will_paginate', '1.0.0'
# gem 'faker',          '1.7.3'   # Used for generating fake data


# added by DJR, 8/16/2019
# gem 'ZenTest', '~> 4.11', '>= 4.11.2'

# added DJR, 01/23/2024
# gem 'select2-rails', '~> 4.0', '>= 4.0.13'

# group :development, :test do
#   gem 'byebug',  '9.0.0', platform: :mri
#   gem 'spring-commands-rspec'
#   gem 'rspec-rails', '~> 3.5'
#   gem 'guard-rspec'
#   gem 'capybara', '~> 2.5'
#   gem 'selenium-webdriver'
#   gem 'factory_girl_rails', '~> 4.5.0'
#   gem 'database_cleaner', '1.3.0'
# end

# group :development, :test, :production do
#   # revised DJR 8/29/2022, apparently must use mysql2 >= 0.4.10
#   # gem 'mysql2', '>=0.3.18', '< 0.5'                               
#   gem 'mysql2', '>= 0.4.10', '< 0.5'
# end

# group :development do
#   gem 'web-console',           '3.1.1'
#   gem 'listen',                '3.0.8'
#   gem 'spring',                '1.7.2'
#   gem 'spring-watcher-listen', '2.0.0'
#   gem 'pry-byebug'
# end

# group :test do
  # gem 'sqlite3'
  # gem 'rails-controller-testing', '0.1.1'
  # gem 'minitest-reporters',       '1.1.9'
  # gem 'guard',                    '2.13.0'
  # gem 'guard-minitest',           '2.4.4'
# end

# group :production do
# #  gem 'pg', '0.18.4'
# end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]