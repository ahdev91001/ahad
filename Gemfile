source 'https://rubygems.org'
#ruby "2.5.5"
# ruby "2.5.9"
ruby "2.6.10"


gem 'rails',          '5.0.7'
gem 'bootstrap-sass', '3.3.7'
gem 'bcrypt',         '3.1.12'
gem 'faker',          '1.7.3'
gem 'will_paginate',           '3.1.6'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'responders',   '2.3.0'
gem 'puma',         '3.9.1'
gem 'sass-rails',   '5.0.6'
gem 'uglifier',     '3.0.0'
gem 'coffee-rails', '4.2.1'
gem 'jquery-rails', '4.1.1'
gem 'turbolinks',   '5.0.1'
gem 'jbuilder',     '2.4.1'
# duplicate, commented out by DJR, 8/21/2019
# gem 'bootstrap-sass', '3.3.7'
gem 'redcarpet',    '~> 3.0.0'
gem 'normalize-scss', '~> 4.0', '>= 4.0.3'
gem 'activemodel-serializers-xml'
gem 'draper', '3.0.1'
gem 'fuzzy-string-match'
gem 'prawn'
gem 'prawn-table'
gem 'geocoder'
gem "cocoon"
gem 'google_maps_service'
gem 'nokogiri', '1.9.1'

# added by DJR, 8/16/2019
gem 'ZenTest', '~> 4.11', '>= 4.11.2'

# added DJR, 01/23/2024
# gem 'select2-rails', '~> 4.0', '>= 4.0.13'

group :development, :test do
  gem 'byebug',  '9.0.0', platform: :mri
  gem 'spring-commands-rspec'
  gem 'rspec-rails', '~> 3.5'
  gem 'guard-rspec'
  gem 'capybara', '~> 2.5'
  gem 'selenium-webdriver'
  gem 'factory_girl_rails', '~> 4.5.0'
  gem 'database_cleaner', '1.3.0'
end

group :development, :test, :production do
  # revised DJR 8/29/2022, apparently must use mysql2 >= 0.4.10
  # gem 'mysql2', '>=0.3.18', '< 0.5'                               
  gem 'mysql2', '>= 0.4.10', '< 0.5'
end

group :development do
  gem 'web-console',           '3.1.1'
  gem 'listen',                '3.0.8'
  gem 'spring',                '1.7.2'
  gem 'spring-watcher-listen', '2.0.0'
  gem 'pry-byebug'
end

group :test do
  gem 'sqlite3'
  gem 'rails-controller-testing', '0.1.1'
  gem 'minitest-reporters',       '1.1.9'
  gem 'guard',                    '2.13.0'
  gem 'guard-minitest',           '2.4.4'
end

group :production do
#  gem 'pg', '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
#
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]