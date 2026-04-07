# Setup Application Server for Deploio

## Prerequisites

Before setting up your application, ensure you have completed the following for Deploio.

### Prerequisites for Deploio

- You've [read about what Deploio is](https://docs.nine.ch/docs/deplo-io/getting-started-with-deploio).
- You have a Deploio account.
- You have installed the `renuo-cli` gem.
- You have installed the `nctl` command.
- You have logged in using `nctl`.

## Setup Your Application

### Setup Deploio Application

#### Remote Configuration

Run [the command to generate a script](https://github.com/renuo/renuo-cli/blob/main/lib/renuo/cli/commands/create_deploio_app.rb) which will create and configure all Deploio apps. `[project-name]` string length is limited to 63 characters:

```sh
renuo create-deploio-app [project-name] [git-url]
```

e.g. `renuo create-deploio-app my-app git@github.com:renuo/my-app.git`

Please review the script before running it and execute only the commands you need and understand.
In particular, you might need only one of the two environments if you decided to not use `develop`.

By default, we setup an Economy database. This comes with a storage capacity limitation of 10 GB. Upgrading to Business is currently not straight-forward (WIP).
If you think that the production database will soon reach the 10 GB, please consider using the Business tier.

**If you don't know what a command does: read the documentation and then execute it.**

If you think that the script is outdated, please open a Pull Request on the [renuo-cli](https://github.com/renuo/renuo-cli) project.

For further configuration and best practices, please refer to the [Deploio documentation](https://guides.deplo.io). You can also view a Ruby on Rails specific guide [here](https://guides.deplo.io/ruby/quick-start.html).

## Next Steps

That's it! You have now configured your application with Deploio. No more configuration is needed.
