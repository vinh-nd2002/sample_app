source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "3.2.2"

gem "rails", "~> 7.0.5"
gem "rails-i18n", "~> 7.0.0"
gem "sprockets-rails"

gem "active_storage_validations", "0.9.8"
gem "config"
gem "image_processing", "1.12.2"
gem "mini_magick", "4.9.5"

gem "bcrypt", "3.1.18"
gem "bootsnap", require: false
gem "bootstrap-sass", "3.4.1"

gem "faker", "2.21.0"
gem "figaro"

gem "importmap-rails"
gem "jbuilder"
gem "mysql2", "~> 0.5"
gem "pagy"
gem "pry-rails", group: :development
gem "puma", "~> 5.0"
gem "sassc-rails", "2.1.2"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i(mingw mswin x64_mingw jruby)

group :development, :test do
  gem "debug", platforms: %i(mri mingw x64_mingw)
  gem "rubocop", "~> 1.26", require: false
  gem "rubocop-checkstyle_formatter", require: false
  gem "rubocop-rails", "~> 2.14.0", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end
