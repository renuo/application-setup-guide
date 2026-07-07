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

The command will copy the necessary templates to `.semaphore` folder using the renuo-cli. These files need to be maintained on the [renuo-cli repository](https://github.com/renuo/renuo-cli/tree/main).
Adapt the files and remove the `develop` related ones if you don't use the `develop` branch.

1. Add a file called `.nvmrc` to the project root, where you specify the latest node version
1. Commit the files to both branches, push and watch the CI run.

When all builds are green, then you have properly configured your CI and CD.

![semaphoreci_2](../images/semaphore_ci.png)

You should now see a third block where your deployment runs to Heroku.
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
