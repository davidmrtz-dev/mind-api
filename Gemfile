source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'action_policy'
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'devise_token_auth'
gem 'faker', '>= 2.13.0'
gem 'net-http'
gem 'pg', '>= 0.18', '< 2.0'
gem 'rack-cors'
gem 'rails', '~> 6.1.1'
gem 'rswag-api'
gem 'rswag-ui'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'database_cleaner-active_record'
  gem 'dotenv-rails'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'rspec-rails'
  gem 'rswag-specs'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'puma', '~> 5.0'
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
