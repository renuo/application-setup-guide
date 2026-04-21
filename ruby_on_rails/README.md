# Ruby On Rails - Application Setup Guide

This setup will cover a pure, monolithic Rails Applications.
This is the most frequent type of application we have at [Renuo](https://renuo.ch) and is probably also the easiest to setup.
The application (and relative GitHub repo) will be named after the `[project-name]` you chose before.

> [!NOTE]
> Have you chosen a `[project-name]` yet? If not, please do so now. Check our [Naming Conventions](../naming_conventions.md)

> [!NOTE]
> Have you decided if you need two environments (develop and main) or just one?
> As a rule of thumb: for customers we always use two environments, for internal projects we usually only use one.
> Why the difference? Because we can bare the risk of having a bug in an internal project, but we cannot do that for a customer.
> Decide with your team if you want one or two branches.

1. [Initialise the Rails Application](app_initialisation.md)
1. [Push to Git Repository](first_git_push.md)
1. [Initialise Gitflow](initialise_gitflow.md)
1. [Configure Github Repository](../configure_git_repository.md)
1. [Create an Application Server for Deploio](create_application_server_deploio.md) or [Create an Application Server for Heroku](create_application_server_heroku.md)
1. [Configure the CI / CD](configure_ci.md)

Once here, your app should be up and running on all environments.

It's now time to introduce some more tools which will help you and the team to keep a high quality during the project development.

1. [RSpec](rspec.md)
1. [Linting and automatic checks](linting_and_automatic_check.md)
1. [Gems and libraries :gem:](suggested_libraries.md)
1. [Cloudflare](cloudflare.md)
1. [README](compile_readme.md)

:tada: Finally you are ready to start working on you new project! :tada:

While everyone starts working there are some more things which you should setup.
Most are not optional, but the rest of the team can start working even if those are not in place yet.

1. [AppSignal](appsignal.md)
1. [Sentry](sentry.md) (optional)
1. [NewRelic](newrelic.md) (optional)
1. [robots.txt](robots_txt.md)
1. [Percy](configure_percy.md) (optional)
1. [Protect develop environment](environment_protection.md)

Some services should be configured accordingly to the packages bought by the customer.
Once the new application is created, please add the project to the
[monitoring list](https://docs.google.com/spreadsheets/d/1FY4jqByO-aI5sDan0hD7ULu6a2-eLsmO6kgdCFlPmuY/edit#gid=0)
and discuss with the PO how the service should be configured.

1. [Uptimerobot](uptimerobot.md)
1. Depending on the monitoring list, also [Sentry notifications](sentry.md) need to be configured.
1. [Depfu security monitoring](depfu.md)
1. Depending on the monitoring list, also [Papertrail alerts](papertrail.md) need to be configured.

Here you will find a series of chapters and guides on how to setup some of the gems we use most often and some other
useful services:

1. [Run Javascript tests with Jest](jest.md)
1. [Pull Requests Template](../pull_requests_template.md)
1. [Slack and Project Notifications](../slack_and_notifications.md)
1. [Send emails](send_emails.md)
1. [Sparkpost & Mailtrap](../sparkpost_and_mailtrap.md)
1. [Devise](devise.md)
1. [Cucumber](cucumber.md)
1. [Object storage](object_storage.md)
1. awesome_print `gem 'awesome_print'`
1. [bootstrap](bootstrap.md)
1. [font-awesome](font_awesome.md)
1. [bullet](bullet.md) `gem 'bullet'`
1. [lograge](appsignal.md) `gem 'lograge'`
1. Rack Tracker (Google Analytics) `gem 'rack-tracker'` --> see [Google Analytics](../google_analytics.md)
1. Favicons
1. [Rack CORS](https://github.com/cyu/rack-cors)
1. [Rack Attack](https://github.com/rack/rack-attack#installing)
1. [:fire: Hotjar](hotjar.md)
1. SEO
    * redirect non-www to www
    * Header tags
1. [wicked pdf](wicked_pdf.md) `gem wicked_pdf`
1. [Recaptcha v3](recaptcha.md)
1. [Wallee Payment Integration](wallee.md)
