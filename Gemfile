source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
gem 'mysql2'

# AWS
gem 'aws-partitions', '~> 1.8'
gem 'aws-sdk-s3', require: false

# ユーザー認証
gem 'devise'

# 環境変数の管理
gem 'gon'
gem 'dotenv-rails'

gem 'font-awesome-sass', '~> 5.4.1'
gem 'mini_magick', '~> 4.8'
gem 'acts-as-taggable-on'
# テストデータの作成
gem 'faker'
gem 'gimei'

# ページネーション
gem 'kaminari'
gem 'kaminari-bootstrap'

# デバッグ
gem 'pry-byebug'
gem 'pry-rails'

# 多言語対応
gem 'rails-i18n'

# 検索機能
gem 'ransack'
gem 'rmagick'
gem 'nested_form_fields'

gem 'rubocop', require: false
gem 'rubocop-rails', require:false

group :test do
  gem 'rspec_junit_formatter'
end
# easy test
group :development, :test do
  gem 'capybara'
  gem 'factory_bot_rails', '~>4.11'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end
# 管理者権限
gem 'rails_admin'
# easier form create
gem 'simple_form'
# Use sqlite3 as the database for Active Record
# image upload
gem 'carrierwave'
# make easier restigation and login
gem "devise"
gem 'omniauth', '1.9.1'
gem 'omniauth-google-oauth2'
# user admin gem
gem 'cancancan'

group :development, :test do
  gem 'dotenv-rails'
end
# Bootstrap for rails
gem 'bootstrap', '~> 4.1.1'
gem 'bootstrap_form'
# Haml for rails
gem 'erb2haml'
gem 'haml-rails'
# Create secure password
gem 'bcrypt', '3.1.11'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end
group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'listen', '~> 3.0.5'
  gem 'web-console'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'rails_12factor'
  gem 'mysql2'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin jruby]

# group :production, :staging do
#     gem 'unicorn'
# end
group :production do
    gem 'unicorn'
end