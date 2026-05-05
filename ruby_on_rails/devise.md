# Devise

> :warning: If you are going to use devise we suggest you to [send_emails](send_emails.md) first.

* Add the following gem `gem 'devise'` and install it

```sh
bundle install
rails generate devise:install
```

* update `config/initializers/devise.rb` and set

```rb
config.secret_key = ENV['DEVISE_SECRET_KEY']
config.mailer_sender = ENV['MAIL_SENDER']
config.pepper = ENV['DEVISE_PEPPER']
```

* add the two variables to the `.env.example`

```bash
DEVISE_SECRET_KEY="rake secret"
DEVISE_PEPPER="rake secret"
```

Open a pull request! 🎉
