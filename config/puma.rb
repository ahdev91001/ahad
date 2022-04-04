workers Integer(ENV['WEB_CONCURRENCY'] || 2)
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/
  # deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  # https://github.com/puma/puma/blob/master/lib/puma/configuration.rb
  # https://github.com/puma/puma#configuration-file
  ActiveRecord::Base.establish_connection
  
  # https://github.com/puma/puma/blob/2668597ec1dd9546d83db9f2ec5ad092add483e6/examples/config.rb#L179
  # https://docs.contrastsecurity.com/en/configure-with-puma.html
  # https://puma.io/puma/Puma/DSL.html#worker_boot_timeout-instance_method
  
  # Despite the below, times out after 34-38 seconds again and again... apparently the main
  # thread keeps running, keeps getting data from the database, and ultimately completes
  # and creates the PDF, but some other thread is timing out and sending a 504 error
  # back to the client...?  My best guess.
  
  worker_timeout 400 
  worker_boot_timeout 400 
  worker_shutdown_timeout 400 
  # first_data_timeout 400 # almost 7 mins... # RESULTS IN: config/puma.rb:21:in `block in _load_from': undefined method `first_data_timeout' for #<Puma::DSL:0x000000000422b970> (NoMethodError)
  
  persistent_timeout 400 
  
  #first_data_timeout(400)
  
end