web: bundle exec puma -C config/puma.rb

web: bundle exec thin start -p $PORT
worker: bundle exec sidekiq -c 5 -v