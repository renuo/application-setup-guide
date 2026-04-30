# Google Analytics

Google Analytics is only set up for the main branch (since \*.renuoapp.ch domains are tracked via Cloudflare injection).

To add a new project to the GA account go to <https://www.google.com/analytics> and login as google@renuo.ch.

1. Go to the tab 'Verwalten' under settings and you will see a dropdown on the left with all the project
1. Chose the option above that says 'Create Account'
1. Fill out the Data based on your project.
1. In Property Management, under Data Steam, choose th platform you'd like to create the tracking for. Make sure 'Enhanced Measurement' is enabled.
1. Once you saved, you will see the tracking snippet. Note: You can always find it again later under Porperty/Data Streams.
1. Write down the Measurement ID (the string in the snippet with all caps and starting with an G-XXX....) and note it - you will need it for the Heroku config.

Choose one of the given options to set up Google Analytics:

## a) Javascript only: gtag script (recommended)

This way is recommended in the normal case, because it doesn't involve another gem dependency. Since Google proposes the
Tag Manager as a default, the Analytics Script is a bit hidden. Tag Manager makes sites slower, therefor one has to decide on a case-by-case basis whether the advantages of a tag manager outweigh the disadvantages. In each case use only the gtag
script which you can find [here](https://developers.google.com/analytics/devguides/collection/gtagjs#install_the_global_site_tag)

```html
<!-- Google tag (gtag.js) -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){window.dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'G-XXXXXXXXXX');
</script>
```

Make sure you insert this script at the end of the `<head>` tag of the page (not in the `<body>`).

> [!NOTE]
> There is a default IP anonymization feature in GA4. We no longer need to perform this step manually.

## b) Ruby rack-tracker

There's a gem which can be used for a lot of trackers: <https://github.com/railslove/rack-tracker#installation>

```rb
group :production do
  ...
  gem 'rack-tracker'
end
```

and write to `config/environments/production.rb`

```ruby
config.middleware.use(Rack::Tracker) do
  if ENV['GOOGLE_ANALYTICS_ID'].present?
    handler :google_analytics, tracker: ENV['GOOGLE_ANALYTICS_ID'], anonymize_ip: true, advertising: true
  end
end
```

