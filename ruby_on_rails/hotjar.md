# 🔥 Hotjar

* Add a new site on the Hotjar dashboard using the Renuo Hotjar account
(credentials are in Passwork). Note the site ID of the generated site.

* Add the following gem to your Gemfile:

```ruby
group :production do
  gem 'rack-tracker'
end
```

* Configure the tracker in `production.rb`:

```ruby
if ENV['HOTJAR_SITE_ID'].present?
    config.middleware.use(Rack::Tracker) do
      handler :hotjar, site_id: ENV['HOTJAR_SITE_ID']
    end
end
```
