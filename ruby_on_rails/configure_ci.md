# Configure the CI

At Renuo we **always** use a CI (Continuous Integration) system to test our applications. It's essential to guarantee
that all the tests pass before building and releasing a new version through our CD system. Our projects use
[SemaphoreCI](<https://semaphoreci.com/>).

> [!NOTE]
> Are you using **Gitlab**? Have a look at [this example](./gitlab_capybara_selenium.md) instead (and elaborate).

Before configuring the CI, you should already have a Git Repository with the code, a `bin/check` command to execute,
and the main branches already pushed and ready to be tested.

1. Proceed to <https://renuo.semaphoreci.com/> and login through GitHub with renuobot@renuo.ch ([1Password](https://start.1password.com/open/i?a=QZNJJCCDWVCGBGI73Z2L55KSGE&v=crlutt26yprmp6thr573qxsxkq&i=u7rirvnrf5fjxd25caiq7ib6vq&h=renuo.1password.com))
1. Follow these instructions to install semaphore CLI: <https://docs.semaphoreci.com/reference/sem-command-line-tool/>
1. Create a project here: <https://renuo.semaphoreci.com/new_project>
1. Go to the project's artifact settings: `Settings` > `Artifacts`
1. Set the retention policy for project, workflow and job artifacts to `/**/*` and `2 weeks`

## Rails specific configuration

```sh
renuo configure-semaphore
```

The command copies the necessary templates to the `.semaphore` folder and creates the Semaphore secret,
the Slack notifications and the `main` and `develop` deployment targets. The templates are maintained in the
[renuo-cli repository](https://github.com/renuo/renuo-cli/tree/main/lib/renuo/cli/templates/semaphore).
If you think they are outdated, please open a Pull Request there.

Adapt the files to your project:

* Remove `develop-deploy.yml`, the `develop` promotion and the `develop` deployment target
  (`sem delete dt develop -p [project-name]`) if you don't use the `develop` branch.
* The deploy pipelines expect the Deploio project to be called `renuo-[project-name]`
  and the apps to be named after the branch (`main`, `develop`), as created by
  [`renuo create-deploio-app`](create_application_server_deploio.md). Adjust the `-p` option otherwise.
* Match the Postgres version in `sem-service start postgres` with the one of your Deploio database.
* If your app needs Node.js, add `nvm install` and `bin/yarn install` to the prologue and
  a `.nvmrc` file to the project root, where you specify the latest node version.

The deploy pipelines use the organization-wide `nctl` Semaphore secret to log in to Deploio.
`renuo ci update-deploio-app` deploys the current revision and `renuo ci check-deploio-status` waits until
the build and the release have succeeded, streaming the build logs into the job output.

Commit the files to both branches, push and watch the CI run.

When all builds are green, then you have properly configured your CI and CD.

![semaphoreci_2](../images/semaphore_ci.png)

You should now see a third block where your deployment runs to Deploio.
Make sure it is green and deploys correctly:

![semaphoreci_2](../images/semaphore_cd.png)

## Conclusion

You have now your application running on all the environments.
From now on, all the changes you will push on *develop* or *main*
branches in GitHub will be automatically deployed to the related server.

It's time to create some first Pull Requests with some improvements.

**Don't forget to go back to the GitHub settings and add the CI to the required checks!**

## A note about contacting the Semaphore support

The Semaphore Support team will use your primary Github email address for communication.
If this is not the `renuo.ch` address, you need to tell them (`support@semaphoreci.com`)
to change your contact email address manually.
