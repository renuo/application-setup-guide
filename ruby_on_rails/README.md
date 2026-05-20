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

> :bulb: **Tip:** Sections marked with ✨ are already set up by the Renuo Rails template or ship with Rails 8.1 by default. You only need to verify them, not install them.

---

## Step 1: Create the App

1. [Initialise the Rails Application](app_initialisation.md)
1. [Push to Git Repository](first_git_push.md)
1. [Initialise Gitflow](initialise_gitflow.md)
1. [Configure Github Repository](../configure_github_repository.md)

## Step 2: Deploy the App

1. [Create an Application Server for Deploio](create_application_server_deploio.md) or [Create an Application Server for Heroku](create_application_server_heroku.md)
1. [Configure the CI / CD](configure_ci.md)

Once here, your app should be up and running on all environments.

## Step 3: Quality Tools

It's now time to introduce some more tools which will help you and the team to keep a high quality during the project development.

1. [RSpec](rspec.md)
1. [Linting and automatic checks](linting_and_automatic_check.md)
1. [Gems and libraries :gem:](suggested_libraries.md)
1. [Cloudflare](cloudflare.md)

:tada: Finally you are ready to start working on you new project! :tada:

## Step 4: Monitoring & Protection

While everyone starts working there are some more things which you should setup.
Most are not optional, but the rest of the team can start working even if those are not in place yet.

1. [AppSignal](appsignal.md)
1. [Sentry](sentry.md) (optional)
1. [NewRelic](newrelic.md) (optional)
1. [robots.txt](robots_txt.md)
1. [Percy](configure_percy.md) (optional)
1. [Protect develop environment](environment_protection.md)

## Step 5: Customer Plan Services

Once the new application is created, please add the project to the
[monitoring list](https://docs.google.com/spreadsheets/d/1FY4jqByO-aI5sDan0hD7ULu6a2-eLsmO6kgdCFlPmuY/edit#gid=0)
and discuss with the PO how the service should be configured.

1. [Uptimerobot](uptimerobot.md)
1. Depending on the monitoring list, also [Sentry notifications](sentry.md) need to be configured.
1. [Depfu security monitoring](depfu.md)
1. Depending on the monitoring list, also [Papertrail alerts](papertrail.md) need to be configured.

---

## Guides & Recipes

The following are not part of the sequential setup. Use them as needed for your project.

* [Run Javascript tests with Jest](jest.md)
* [Pull Requests Template](../templates/pull_requests_template.md)
* [Slack and Project Notifications](../slack_and_notifications.md)
* [Send emails](send_emails.md)
* [Sparkpost & Mailtrap](../sparkpost_and_mailtrap.md)
* [Devise](devise.md)
* [Cucumber](cucumber.md)
* [Object storage](object_storage.md)
* awesome_print `gem 'awesome_print'`
* [bootstrap](bootstrap.md)
* [font-awesome](font_awesome.md)
* [bullet](bullet.md) `gem 'bullet'`
* [lograge](appsignal.md#lograge) `gem 'lograge'`
* Rack Tracker (Google Analytics) `gem 'rack-tracker'` --> see [Google Analytics](../google_analytics.md)
* Favicons
* [Rack CORS](https://github.com/cyu/rack-cors)
* [Rack Attack](https://github.com/rack/rack-attack#installing)
* [:fire: Hotjar](hotjar.md)
* SEO
  * redirect non-www to www
  * Header tags
* [wicked pdf](wicked_pdf.md) `gem wicked_pdf`
* [Recaptcha v3](recaptcha.md)
* [Wallee Payment Integration](wallee.md)
