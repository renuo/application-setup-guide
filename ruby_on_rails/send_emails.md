# 📬 Send Emails

As soon as you have to send emails please follow those suggestions.
They will help you having a proper system to deliver emails and development environment.

## Configuration

* Add the following to your Gemfile and `bundle install`

```ruby
group :development do
  gem 'letter_opener'
end
```

* add the following to `.env.example`

```yml
APP_HOST="[project-name].localhost"
APP_PORT="3000"
MAIL_SENDER="yourname+<application>@example.com"
MAIL_HOST=""
MAIL_USERNAME=""
MAIL_PASSWORD=""
```

* update `app/mailers/application_mailer.rb`

```ruby
class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAIL_SENDER')  # <-- change this
  layout 'mailer'
end
```

* add the following to `config/application.rb`

```ruby
config.action_mailer.default_url_options = { host: ENV.fetch('APP_HOST'), port: ENV.fetch('APP_PORT') }
```

* add the following to `config/environments/development.rb`:

```ruby
config.action_mailer.delivery_method = :letter_opener
```

* add the following `config/environments/production.rb`:

```ruby
config.action_mailer.smtp_settings = {
  address: ENV.fetch('MAIL_HOST'),
  port: 587,
  enable_starttls_auto: true,
  user_name: ENV.fetch('MAIL_USERNAME'),
  password: ENV.fetch('MAIL_PASSWORD'),
  authentication: 'login',
  domain: ENV.fetch('APP_HOST')
}
```

## Sparkpost & Mailtrap

Follow the [sparkpost](../sparkpost_and_mailtrap.md) section to configure Sparkpost and Mailtrap on your production environment
