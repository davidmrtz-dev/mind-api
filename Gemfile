source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.4'

gem 'rails', '~> 6.1.1'
gem 'pg', '>= 0.18', '< 2.0'
gem 'devise_token_auth'
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'net-http'
gem 'rack-cors'
gem 'faker', '>= 2.13.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'database_cleaner-active_record'
  gem 'dotenv-rails'
  gem 'guard'
  gem 'guard-rspec', require: false
  gem 'rspec-rails'
  gem 'shoulda-matchers'
end

group :development do
  gem 'puma', '~> 5.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'solargraph'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
