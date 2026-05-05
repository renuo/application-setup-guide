# Sentry

## General configuration

* Go to <https://www.sentry.io> and login as the renuo monitor user.

* Create a project named `[project-name]`.

* Add the project to the *#renuo* team if the client pays for monitoring, to the `#no-notifications` otherwise.

* Note the DSN key.

  ![sentry_dsn](../images/sentry.png)

Add the ENV variables to the `.env` files for each environment.

Use the **same** `SENTRY_DSN` across all environments, but set a different `SENTRY_ENVIRONMENT` in each environment (e.g. `main`, `develop`).

This allows all errors to be tracked in a single Sentry project while still being grouped by environment.

The project's Sentry issues can be monitored on the [Renuo Dashboard](https://dashboard.renuo.ch/redmine_projects). To configure this, ensure that the `dash` attribute for the project on Redmine is equal to the Sentry project name.

The different environments will be automatically detected, and you can monitor and view the Sentry issues from one place.

## Backend (Rails)

* Add sentry gems to the project:

  ```ruby
  group :production do
    gem "sentry-rails"
    gem "sentry-ruby"
  end
  ```

* Add a Sentry initializer to your project [`config/initializers/sentry.rb`](../templates/config/initializers/sentry.rb).
* Add the following to your `.env.example` file:
```bash
# .env.example
# SENTRY_DSN="find_me_on_password_manager"
# SENTRY_ENVIRONMENT="local"
# CSP_REPORT_URI=""
```

* Enable CSP Reporting to Sentry in `config/initializers/content_security_policy.rb` and allow unsafe inline JS:

  ```ruby
  Rails.application.config.content_security_policy do |policy|
    ...
    policy.report_uri ENV['CSP_REPORT_URI'] if ENV['CSP_REPORT_URI']
  end
  ```

  You can find the correct value in `Sentry -> Project Settings -> Security Headers -> REPORT URI`. Add the environment to the `CSP_REPORT_URI` using `&sentry_environment=main`.

## Frontend (Javascript)

* Install the npm package: `yarn add @sentry/browser`
* Include [_sentry.html](../templates/app/views/shared/_sentry.html.erb) in your header.
* Include [sentry.js](../templates/app/javascript/sentry.js) in your JS assets.

## Verify the installation

### Ruby

For each Heroku app, connect to the `heroku run rails console --app [project-name]-[branch-name]` and raise an exception using Sentry:

```
begin
  1 / 0
rescue ZeroDivisionError => exception
  Sentry.capture_exception(exception)
end
```

On `https://sentry.io/renuo/[project-name]` you should find the exception of the ZeroDivisionError.

### Javascript

Open the dev console in chrome, and run

```js
try {
    throw new Error('test sentry js');
} catch(e) {
    Sentry.captureException(e)
}
```

On `https://sentry.io/renuo/[project-name]` you should find "Uncaught Error: test sentry js".
