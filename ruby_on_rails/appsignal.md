# Logs & error monitoring with AppSignal

AppSignal is a service to record logs, monitor errors and performance.
Recording logs works independently from the tech stack. So you should use AppSignal
to record logs even if you don't use Rails. In Heroku we'll add a log drain to
redirect the multiplexed Logplex logs to AppSignal in any case.

1. [Backend](#backend)
2. [Frontend](#frontend)
3. [Verify the installation](#verify-the-installation)

## Backend

### Logs & errors

If you want to log errors and metrics, you need to install the AppSignal agent
into your app. See integration instructions for [Ruby/Rails](https://docs.appsignal.com/logging/platforms/integrations/ruby.html).

* Add the following gem to your Gemfile (our fork adds a configurable sampling rate to reduce logging costs):
  ```ruby
  gem 'appsignal', github: 'renuo/appsignal-ruby'
  ```
* Add a AppSignal configuration file [`config/appsignal.rb`](../templates/config/appsignal.rb)
* Add the new variables to your Deploio environments:

  ```yml
  APPSIGNAL_APP_ENV: "main | develop"
  APPSIGNAL_APP_NAME: "project name without env"
  APPSIGNAL_IGNORE_ERRORS: "ActiveRecord::RecordNotFound,ActionController::UnknownFormat"
  APPSIGNAL_PUSH_API_KEY: "from appsignal"
  # APPSIGNAL_SAMPLING_RATE: "1.0'
  ```

We use the same push key for all apps. You can either copy it from another project or "create" an app on appsignal.
This will just show you the key and tell you to deploy the app with it for the app to be created.

Once you deploy the app and collect data the app will show up in the appsignal dashboard.
Navigate to **Logging** -> **Manage Resources** and **Add log resource** with these settings:

| Setting        | Value              |
| -------------- | ------------------ |
| Source name    | `Rails`            |
| Platform       | `Heroku Log Drain` |
| Message format | `logfmt`           |

Then add this ingestion endpoint as a log drain using the Heroku commands displayed.

### Only Logs

Choose the "JavaScript" option on the AppSignal project page to
setup your project without an active agent.

### Configuration adjustments

#### Correct Severity

According to [the docs](https://docs.appsignal.com/logging/platforms/heroku.html), getting the severity to be anything but "INFO" is not possible using the heroku drain.

However, there is now a way to send the `"severity=XYZ"` logfmt information and have that be applied correctly in appsignal. Unfortunately, just setting this seems to break the recognition of `request_id` in the format `[1234-5678]`. So we have to override the `ActiveSupport::TaggedLogging::Formatter` to add both the `severity` and the `request_id` in logfmt syntax.

```ruby
# frozen_string_literal: true

if Rails.env.production?
  module ActiveSupport
    module TaggedLogging
      module Formatter
        def call(severity, timestamp, progname, msg)
          logfmt_msg = ["severity=#{severity}", tags_text, msg].compact.join(' ')
          super(severity, timestamp, progname, logfmt_msg)
        end

        def tags_text
          current_tags.map do |tag|
            if tag.is_a? Hash
              tag.map { |k, v| "#{k}=#{v}" }
            else
              "[#{tag}]"
            end
          end.flatten.join(' ')
        end
      end
    end
  end
end
```

and

```ruby
# config/environments/production.rb
Rails.application.configure do
  # We use our custom key value tagging
  config.log_tags = [->(request) { { request_id: request.request_id } }]
  logger           = ActiveSupport::Logger.new(STDOUT)
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
end
```

### Lograge

We use [lograge](https://github.com/roidrage/lograge) in many projects. Here is how to configure
it with AppSignal to get properly tagged logs.

Using this configuration we get the fully tagged lograge lines and also
the full stack trace with each line tagged with the request id. This allows
us to filter by request id with one click and get all relevant log data at once.

_With AppSignal gem_

```ruby
# config/initializers/lograge.rb
if ENV['LOGRAGE_ENABLED'] == 'true'
  Rails.application.configure do
    config.lograge.enabled = true
    config.lograge.keep_original_rails_log = true
    config.lograge.logger = Appsignal::Logger.new(
      "rails",
      format: Appsignal::Logger::LOGFMT
    )
    config.lograge.custom_payload do |controller|
      {
        request_id: controller.request.request_id
      }
    end
  end
end
```

_Without AppSignal gem_

```ruby
# config/environments/production.rb
Rails.application.configure do
  …

  if ENV['RAILS_LOG_TO_STDOUT'].present?
    config.log_tags = [->(request) { { request_id: request.request_id } }]
    logger          = ActiveSupport::Logger.new($stdout)
    config.logger   = ActiveSupport::TaggedLogging.new(logger)
  end
end
```

```ruby
# config/initializers/lograge.rb
Rails.application.configure do
  …

  if ENV['LOGRAGE_ENABLED'] == 'true'
    config.lograge.enabled = true
    config.lograge.keep_original_rails_log = true
  end
end
```

### Automation

Unfortunately Appsignal doesn't provide an API for project configuration.
So if you need to do something on a lot of projects, you have to do it manually.

Project creation can be automated though with the following script.
Run it in a tmp folder. **It writes into a file on disk.**

```rb
#!/usr/bin/env ruby
require 'optparse'
require 'appsignal'
require 'appsignal/demo'

PUSH_API_KEY = "XXX"

options = {}
OptionParser.new do |opt|
  opt.on('--env APPSIGNAL_ENV') { |o| options[:env] = o }
  opt.on('--name APPSIGNAL_NAME') { |o| options[:name] = o }
end.parse!

raise OptionParser::MissingArgument if options[:env].nil? || options[:name].nil?

File.write 'config/appsignal.rb', <<~RUBY
  if defined?(Appsignal)
    Appsignal.configure do |config|
      %w[HTTP_REFERER HTTP_USER_AGENT HTTP_AUTHORIZATION REQUEST_URI].each do |header|
        config.request_headers << header
      end
      config.revision = ENV.fetch("DEPLOIO_GIT_REVISION")
    end
  end
RUBY

Appsignal.config = Appsignal::Config.new(Dir.pwd, options[:env])
Appsignal::Demo.transmit
```

## Frontend

While the backend uses a secret `PUSH_API_KEY` to authenticate with AppSignal, the frontend uses a public `FRONTEND_API_KEY`
to authenticate with AppSignal. This key can only be read once the project is created on AppSignal.
So once the project is created, the frontend API key can be found in the "Push and deploy" section of your project settings.

Checkout the [AppSignal documentation](https://docs.appsignal.com/front-end/installation.html) if you need more information.

_Installation steps:_
* Add the new frontend API key to your Heroku environments:
  ```yml
  APPSIGNAL_FRONTEND_API_KEY: "from appsignal"
  ```
* Install the package: `yarn add @appsignal/javascript`
* Include [_appsignal.html](../templates/app/views/shared/_appsignal.html.erb) in your header.
```erb
<%= render 'shared/appsignal' %>
```
* Include [appsignal.js](../templates/app/javascript/appsignal.js) in your JS assets.

## Verify the installation

### Error monitoring

#### Ruby

For each environment of your app, connect to the `heroku run rails console --app [project-name]-[branch-name]` and raise an exception using Appsignal:

```
begin
  1 / 0
rescue ZeroDivisionError => exception
  Appsignal.send_error(exception)
end
```

You should find the exception of the ZeroDivisionError on Appsignal after a minute or two.

#### Javascript

Open the dev console in chrome, and run

```js
try {
  throw new Error('test appsignal js');
} catch(e) {
  Appsignal.sendError(e)
}
```

On Appsignal you should find "Uncaught Error: test appsignal js".
