# Setup RSpec

Even though Rails uses Minitest per default, RSpec is the *de-facto* standard at Renuo.

Add the following gems to your Gemfile:

```ruby
group :development, :test do
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "parallel_tests"
end

group :test do
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "super_diff"
end
```

You should know exactly why you are adding each one of them and why is necessary.

* Also add `/coverage/` to your `.gitignore` file.
* Remove the `test` folder from your project (there will be one called `spec` later).

## Configuration

* Install rspec via `rails generate rspec:install`
* Create a bin stub with `bundle binstubs rspec-core`

### spec/spec_helper.rb

Add SimpleCov configuration at the top of the file (before `RSpec.configure`):

```ruby
# Run code coverage and exclude files with less than 5 lines of code
unless ENV["NO_COVERAGE"]
  require "simplecov"
  SimpleCov.start "rails" do
    add_filter "app/channels/application_cable/channel.rb"
    add_filter "app/channels/application_cable/connection.rb"
    add_filter "app/jobs/application_job.rb"
    add_filter "app/mailers/application_mailer.rb"
    add_filter "app/models/application_record.rb"
    add_filter ".semaphore-cache"
    enable_coverage :branch
    enable_coverage_for_eval
    minimum_coverage line: 100, branch: 100
  end
end
```

Add the following configuration options inside the `RSpec.configure` block:

```ruby
RSpec.configure do |config|
  # ... existing configuration ...

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.run_all_when_everything_filtered = true

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end
```

We suggest you to also unable/uncomment the following:

```ruby
config.disable_monkey_patching!
config.default_formatter = "doc" if config.files_to_run.one?
config.profile_examples = 5
config.order = :random
Kernel.srand config.seed
```

### spec/rails_helper.rb

Add the following requires:

```ruby
# after `require "rspec/rails"`
require "capybara/rspec"
require "capybara/rails"
require "selenium/webdriver"
require "super_diff/rspec-rails"
```

Add the following after the requires (before `RSpec.configure`):

```ruby
Rails.root.glob("spec/support/**/*.rb").each { |f| require f }
```

Add the following configuration inside the `RSpec.configure` block:

```ruby
RSpec.configure do |config|
  # ... existing configuration ...

  config.include FactoryBot::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include JavaScriptErrorReporter, type: :system, js: true
  config.include Capybara::RSpecMatchers, type: :request

  config.infer_spec_type_from_file_location!

  config.before do |example|
    ActionMailer::Base.deliveries.clear
    I18n.locale = I18n.default_locale
    Rails.logger.debug { "--- #{example.location} ---" }
  end

  config.after do |example|
    Rails.logger.debug { "--- #{example.location} FINISHED ---" }
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:all, type: :system) do
    Capybara.server = :puma, { Silent: true }
  end

  config.before(:each, type: :system, js: true) do
    driven_by ENV["SELENIUM_DRIVER"]&.to_sym || :selenium_chrome_headless
    Capybara.page.current_window.resize_to(1280, 800)
  end
end
```

### .env.example

```yml
# SELENIUM_DRIVER="selenium_chrome"
SELENIUM_DRIVER="selenium_chrome_headless"
```

### config/environments/development.rb

```rb
config.generators do |g|
  g.test_framework :rspec
end

```

* Add the line `bundle exec parallel_rspec` to `bin/check`

> **Note**: If you want to debug a spec, you can simply uncomment the line `SELENIUM_DRIVER` in the .env to not run it headless:

![CleanShot 2021-06-25 at 16 54 22](https://user-images.githubusercontent.com/1319150/123443347-1bbcae80-d5d6-11eb-8ba5-0d2c9ae4a37c.gif)

## :white_check_mark: Our first (green) test

We are now going to write a first test to ensure that the whole configuration is working:

* `bin/check` should be green :white_check_mark:
* Write the test [`spec/system/health_spec.rb`](../templates/spec/system/health_spec.rb)
* Run `bin/check` and the test should pass and coverage is 100%.

Commit and push your changes! :tada:

> ⭐️ The default health check path for Rails is `/up`. [Learn more in the Rails guides](https://edgeapi.rubyonrails.org/classes/Rails/HealthController.html).\
> To customize the health check and add additional checks, you can override the `Rails::HealthController` class.\
> You can find an example that also checks the database connection [in this file](../templates/app/controllers/rails/health_controller.rb).

## Verify

Check that you see a green page in each app.

### Heroku

* Open the two apps
  * <https://[project-name]-main.herokuapp.com/up>
  * <https://[project-name]-develop.herokuapp.com/up>

### Deploio

The host name contains a generated hash. The name can be accessed via:

```sh
nctl get applications --project={PROJECT_NAME}
```

## Javascript error reporter

* Create the module [`spec/support/javascript_error_reporter.rb`](../templates/spec/support/javascript_error_reporter.rb)
