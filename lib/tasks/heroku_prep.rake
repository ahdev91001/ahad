require_relative '../util_rake'
include UtilRake

# From http://stackoverflow.com/questions/1325865/
#   what-is-the-standard-way-to-dump-db-to-yml-fixtures-in-rails
# With additional fix to work on cloud9 found at:
#   http://stackoverflow.com/questions/23336755/
#   activerecordadapternotspecified-database-configuration-does-not-specify-adapte
#   (search for answer with "#{Rails.env}".to_sym -- that fix did the trick. )
namespace :heroku do
  desc 'Prepare environment for a successful "git push (staging|heroku)"'
  task :prep => :environment do
    puts "Nothing specific to do yet, but if it comes up, put it here. :)"
    puts "\nAll done!  Go deploy like a boss!!!\n\n"
  end
end