# Initialise the Rails Application

## Default Rails setup

* Ensure that your mise plugins are up to date with `mise plugin update`.

* Ensure you are using the latest Ruby version globally (`mise use -g ruby@latest`) and that it is
  supported by Deploio.

* Run `gem update --system` to update Ruby's default gems (e.g. `bundler`).

* [Check if you are using the latest stable version of Rails](http://rubyonrails.org/) with `rails -v` and update it if you are not.
You can do this with `gem update rails`. Beware of beta versions.

* Start a new Rails project using
```
rails new [project-name] --database=postgresql --skip-kamal --skip-ci --skip-action-mailbox --template https://raw.githubusercontent.com/renuo/application-setup-guide/main/ruby_on_rails/template.rb
```
where the `project-name` is exactly the one you chose before.

> ⚠️ You may want to choose a different database than Postgres, but most of the time this will be your choice.\
> You might also need actionmailbox of course, so always double-check the parameters that you are using.

> ⭐️ This setup does not include either js-bundling nor css-bundling by default.\
> It will start with the simplest possible Rails setup and will use sprockets and importmaps.\
> If you need to do fancy stuff, discuss with your team the opportunity of including a js-bundling and css-bundling tool.\
> We want to go ["no build"](https://www.youtube.com/watch?v=iqXjGiQ_D-A) whenever possible.

* Run `bundle exec rails db:migrate` to generate an empty `schema.rb` file.
* Run `bin/setup`

* Then check your default Rails setup by running `bin/run` and visiting http://[project-name].localhost:3000.
  You should be on Rails now, yay!
* Finally check if http://localhost:3000/up is green.

## Adjustments

Some adjustments are made automatically by the template, but you should check them.
Some other adjustments must be performed manually.

### Automatic adjustments

> ⭐The Gemfile reads the required ruby version from the `.ruby-version` file.
> [This is used by Heroku to determine what version to use.](https://devcenter.heroku.com/articles/ruby-versions)
> Deploio reads the ruby version from the Gemfile, with the .ruby-version file inlined into it. https://paketo.io/docs/howto/ruby/#override-the-detected-ruby-version

> ⭐️renuocop replaces the default rubocop-rails-omakase. We have our own set of rules at Renuo.
> You can discuss them at https://github.com/renuo/renuocop and you can also contribute to them.

> ⭐️a bin/check script is added to the project. This script will run all the tests of the project.
> It is used in our CI and can be used locally to check if everything is fine. You can customize it to your needs.

> ⭐️a bin/fastcheck script is added to the project.
> This script will run all the linters of the project. It is used in our CI and can be customized to your needs.
> It will be used as a hook before pushing to quickly check for linting issues.

> ⭐️a bin/run script is added to the project. This script will start the application.

> ⭐️bin/check, bin/fastcheck and bin/run are standardized tools for more convenience at Renuo.

### Secrets

We store the secrets necessary to configure the project locally in a 1password Item.
Create a new Item for the project called `[project-name] project secrets` of type note.
Right click on the vault and select `Copy Private link`.

* Run the command `renuo fetch-secrets --init [the vault private link]` to create an empty secrets file.

The Item contains the fields that represent the ENV variables. You can use Text or Password fields.
Check existing projects for an example of the usage.

#### Configuration customisation

* Update `config/application.rb` and set the default language and timezone

  ```ruby
  config.time_zone = 'Zurich'
  config.i18n.default_locale = :de
  ```

* Update your `config/environments/production.rb` settings:

  ```ruby
  config.force_ssl = true # uncomment
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "warn") # change
  ```

* Update `config/environments/development.rb` settings:

  ```ruby
  config.action_controller.action_on_unpermitted_parameters = :raise
  config.i18n.raise_on_missing_translations = :strict

  config.generators.apply_rubocop_autocorrect_after_generate!
  ```

* Update `config/environments/test.rb` settings:

  ```ruby
  config.action_controller.action_on_unpermitted_parameters = :raise
  config.i18n.raise_on_missing_translations = :strict
  config.i18n.exception_handler = Proc.new { |exception| raise exception.to_exception } # add
  config.active_record.verbose_query_logs = true # add

  # add the following lines to the end of the file
  config.to_prepare do
    ActiveSupport.on_load(:active_record) do
      ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.create_unlogged_tables = true
    end
  end
  ```

* The default [Content Security Policies](./content_security_policy.md) should not always be activated, but rather only where there are platform secrets that need to be secured. This rule can be overwritten by a customer, if he opted into CSP when selecting his maintenance plans.

* If you're using a js-bundling tool, let's clean up after asset precompilation
  to reduce the size of your deployment. Although deplo.io doesn't have Heroku slugs, it is still good to set up. Add this to the `Rakefile`:

  ```ruby
  Rake::Task['assets:clean'].enhance do
    FileUtils.remove_dir('node_modules', true)
    FileUtils.remove_dir('vendor/javascript', true)
  end
  ```

## Finalising

* Check if the following scripts run successfully: `bin/setup`, `bin/check`, `bin/run`
* If they do, commit all your changes to the main branch with Git.
