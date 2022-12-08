source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.4'
# Use mysql as the database for Active Record
gem 'mysql2' # , '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  gem 'rspec-rails', '4.0.2'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem 'capistrano3-puma'
  gem 'capistrano-rvm'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'action-cable-testing'
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.11.1'
  gem 'faker'
  gem 'shoulda-matchers', '4.1.2'
  gem 'rails-controller-testing' 
  gem 'simplecov', require: false
  # gem 'webmock'
end
gem 'activesupport'
gem 'aws-sdk', '~> 3'
gem 'carrierwave'
gem 'carrierwave-aws', github: 'sorentwo/carrierwave-aws', branch: :master
gem 'carrierwave-base64'
gem 'counter_culture', '~> 2.0'

gem 'devise_token_auth', github: 'lynndylanhurley/devise_token_auth', branch: :master

gem 'faraday'
gem 'figaro'
gem 'friendly_id', '~> 5.1.0'
gem 'jsonapi-serializer'
gem 'kaminari'
gem 'minidusen'
gem 'mini_magick'
gem 'i18n_data'
gem 'rack-cors', require: 'rack/cors'
gem 'rspec-core'
gem 'rubocop-rspec'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
