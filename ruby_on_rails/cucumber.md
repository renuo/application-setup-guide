# Cucumber

[Cucumber](https://cucumber.io) is a testing framework which allows us to specify feature tests using plain language.
We use Cucumber for e2e tests in some of our projects. We integrate it using the `cucumber-rails` gem.

## Installing `cucumber-rails`

The installation process of `cucumber-rails` is also documented on its
[Github page](https://github.com/cucumber/cucumber-rails).

To install `cucumber-rails`, add the following gems to your Gemfile:

```rb
group :test do
    gem 'capybara', require: false
    gem 'cucumber-rails', require: false
    gem 'database_cleaner'
end
```

Run `bundle install` to install the gems.

Finally, set up Cucumber with

```sh
rails generate cucumber:install
```

At this time, it is recommended to inspect the generated files and commit. Before committing, make sure, Rubocop does
not raise any issues. Therefore, you will have to add the following exception to `.rubocop.yml`:

```yaml
AllCops:
  Exclude:
    - 'lib/tasks/cucumber.rake'
```

## Running your first Cucumber test

If you add Cucumber to an existing project, test a real page instead of using the given example test.

Add the following files:

* [`app/controllers/home_controller.rb`](../templates/app/controllers/home_controller.rb) (If you haven't done so
already) in the [RSpec](rspec.md) section.
* [`features/home_check.feature`](../templates/features/home_check.feature)
* [`features/step_definitions/home_check_steps.rb`](../templates/features/step_definitions/home_check_steps.rb)

Now, you can run Cucumber in your terminal:

```sh
cucumber
```

You may get a couple of deprecation warnings. There is currently an
[issue](https://github.com/cucumber/cucumber-rails/issues/346) about them on the Github page of `rspec-rails`

## Adding Cucumber tests to `bin/check`

Add the following code to `bin/check`, so the Cucumber tests are run on CI:

```sh
NO_COVERAGE=true bundle exec cucumber --format progress
if [ $? -ne 0 ]; then
  echo 'Cucumber did not run successfully, commit aborted'
  exit 1
fi
```

Assure that `bin/check` fails, if you have a broken Cucumber test.

## Custom environment

Probably, you are going to need the following configuration files in `/features/env`:

* [`capybara.rb`](../templates/features/env/capybara.rb) enables headless Chrome. This is needed in Cucumber tests
which require Javascript (i.e. scenarios tagged with `@javascript`).
* [`database_cleaner.rb`](../templates/features/env/database_cleaner.rb) sets up `database_cleaner` for Cucumber tests.
* [`factory_bot.rb`](../templates/features/env/factory_bot.rb) makes FactoryBot's methods (like `build` and `create`)
accessible in the step definition file.
* [`warden.rb`](../templates/features/env/warden.rb) sets up the test environment, if you are using Warden (i.e. if you
are using Devise).
