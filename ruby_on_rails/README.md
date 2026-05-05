# Ruby On Rails - Application Setup Guide

This setup covers a pure, monolithic Rails application.
This is the most frequent type of application at [Renuo](https://renuo.ch) and is probably the easiest to set up.
The application (and its GitHub repo) will be named after the `[project-name]` you chose before.

> **Note:** Have you chosen a `[project-name]` yet? If not, please do so now. Check our [Naming Conventions](../naming_conventions.md)

> **Note:** Have you decided if you need two environments (develop and main) or just one?
> As a rule of thumb: for customers we always use two environments, for internal projects we usually only use one.
> Why the difference? Because we can bear the risk of having a bug in an internal project, but we cannot do that for a customer.
> Decide with your team if you want one or two branches.

> :bulb: **Tip:** Sections marked with ✨ are already set up by the Renuo Rails template or ship with Rails 8.1 by default. You only need to verify them, not install them.

---

## Step 1: Create the App

1. [Initialise the Rails Application](app_initialisation.md)
1. [Push to Git Repository](first_git_push.md)
1. [Initialise Gitflow](initialise_gitflow.md)
1. [Configure GitHub Repository](../configure_git_repository.md)

## Step 2: Deploy the App

1. [Create an Application Server for Deploio](create_application_server_deploio.md) or [Create an Application Server for Heroku](create_application_server_heroku.md)
1. [Configure the CI/CD](configure_ci.md)

Your app should now be up and running on all environments.

## Step 3: Quality Tools

Set up the tools that help your team maintain high quality throughout development.

1. [RSpec](rspec.md)
1. [Linting and automatic checks](linting_and_automatic_check.md)
1. [Gems and libraries](suggested_libraries.md)
1. [Cloudflare](cloudflare.md)

Your team can now start working on the project.

## Step 4: Monitoring & Protection

Set these up while the rest of the team starts working. Most are not optional, but they don't block other work.

1. [AppSignal](appsignal.md)
1. [Sentry](sentry.md) (optional)
1. [NewRelic](newrelic.md) (optional)
1. [robots.txt](robots_txt.md)
1. [Percy](configure_percy.md) (optional)
1. [Protect develop environment](environment_protection.md)

## Step 5: Customer Plan Services

Once the application is created, add the project to the
[monitoring list](https://docs.google.com/spreadsheets/d/1FY4jqByO-aI5sDan0hD7ULu6a2-eLsmO6kgdCFlPmuY/edit#gid=0)
and discuss with the PO how the services should be configured.

1. [Uptimerobot](uptimerobot.md)
1. Depending on the monitoring list, also [Sentry notifications](sentry.md) need to be configured.
1. [Depfu security monitoring](depfu.md)
1. Depending on the monitoring list, also [Papertrail alerts](papertrail.md) need to be configured.

---

## Guides & Recipes

The following are not part of the sequential setup. Use them as needed for your project.

* [Run JavaScript tests with Jest](jest.md)
* [Pull Requests Template](../templates/pull_requests_template.md)
* [Slack and Project Notifications](../slack_and_notifications.md)
* [Send emails](send_emails.md)
* [Sparkpost & Mailtrap](../sparkpost_and_mailtrap.md)
* [Devise](devise.md)
* [Cucumber](cucumber.md)
* [Object storage](object_storage.md)
* awesome_print `gem 'awesome_print'`
* [Bootstrap](bootstrap.md)
* [FontAwesome](font_awesome.md)
* [Bullet](bullet.md) `gem 'bullet'`
* [Lograge](appsignal.md#lograge) `gem 'lograge'`
* Rack Tracker (Google Analytics) `gem 'rack-tracker'` → see [Google Analytics](../google_analytics.md)
* Favicons
* [Rack CORS](https://github.com/cyu/rack-cors)
* [Rack Attack](https://github.com/rack/rack-attack#installing)
* [Hotjar](hotjar.md)
* SEO
  * redirect non-www to www
  * Header tags
* [Wicked PDF](wicked_pdf.md) `gem wicked_pdf`
* [Recaptcha v3](recaptcha.md)
* [Wallee Payment Integration](wallee.md)
