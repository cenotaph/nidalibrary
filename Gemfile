source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.1.3.2'
# Use mysql as the database for Active Record
gem 'mysql2' # , '>= 0.4.4'
# Use Puma as the app server
gem 'puma', '~> 6'
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
  gem 'capistrano' #, '3.10.1'
  gem 'capistrano3-nginx', '~> 3.0.4'
  gem 'capistrano3-puma', github: "seuros/capistrano-puma"
  gem 'capistrano-bundler' #, '1.1.4'
  gem 'capistrano-rails' #, '1.1.3'
  gem 'capistrano-rvm'
  gem 'listen' # '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'action-cable-testing'
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 4.11.1'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'shoulda-matchers', '4.1.2'
  gem 'simplecov', require: false
  # gem 'webmock'
end
gem 'activesupport'
gem 'aws-sdk-s3', '~> 1'
gem 'bcrypt_pbkdf'
gem 'carrierwave'
gem 'carrierwave-aws', github: 'sorentwo/carrierwave-aws', branch: :master
gem 'carrierwave-base64'
gem 'counter_culture', '~> 2.0'
gem 'csv'
gem 'devise_token_auth', '>= 1.2.0', git: "https://github.com/lynndylanhurley/devise_token_auth"
gem 'ed25519'
gem 'faraday'
gem 'figaro'
gem 'friendly_id' #, '~> 5.1.0'
gem 'i18n_data'
gem 'jsonapi-serializer'
gem 'kaminari'
gem 'minidusen'
gem 'mini_magick'
gem 'rack-cors', require: 'rack/cors'
gem 'rspec-core'
gem 'rubocop-rspec'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
