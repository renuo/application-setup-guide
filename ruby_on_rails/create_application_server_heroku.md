# Setup Application Server for Heroku

## Prerequisites

- You've [read about what Heroku is](https://www.heroku.com/platform).
- You have a Heroku account.
- You have installed the `renuo-cli` gem.

## Setup

Run the command to generate a script which will create and configure all Heroku apps. `[project-name]` string length is limited to 22 characters:

```sh
renuo create-heroku-app [project-name]
```

Please review the script before running it and execute only the commands you need and understand.
In particular, you might need only one of the two environments if you decided to not use `develop`.

**If you don't know what a command does: read the documentation and then execute it.**

If you think that the script is outdated, please open a Pull Request on the [renuo-cli](https://github.com/renuo/renuo-cli) project.

## Setup Rails for Heroku

1. Add a file called `Procfile` to your code root:

```sh
web: bundle exec puma -C config/puma.rb
```

This file is read by Heroku to start the web app and worker jobs.

2. Add a file called `.slugignore` to your code root:

```sh
/spec
/.semaphore
```

This file allows you to mark files and folders to be excluded from the Heroku
