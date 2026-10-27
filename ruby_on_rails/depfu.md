# Depfu

Depfu is a service which checks out the Gemfile / yarn.lock of a project for problematic
dependencies. It will automatically create a pull request to the project
if a security vulnerability has been disclosed.

1. Ask wg-operations to add repository access for Depfu to you new Github
   repository.

That's all :-)

Update strategy should be set to `Grouped Updates`, frequency: `monthly`. Assignee should be set.

## Engine Updates

Enable minor engine updates. Currently [in 7 days after release](https://depfu.com/blog/previously-on-depfu#:~:text=We%E2%80%99ve%20heard%20from%20you%20that%20engine%20releases%20(so%20new%20versions%20of%20Ruby%2C%20nodejs%2C%20etc.)%20often%20get%20stuck%20waiting%20for%20upstream%20providers%20like%20Heroku%2C%20Docker%20and%20similar%20to%20make%20the%20new%20version%20available.%20So%20now%20we%20simply%20wait%20for%207%20days%20before%20we%20send%20you%20the%20PR%20for%20a%20new%20version.).

![Depfu Engine Updates](../images/depfu_engine_updates.png)

> [!NOTE]
> If you are using Heroku, the latest Ruby / node version may not yet
> be available on their platform, so you may need to delay the upgrade. Check the
> following GitHub repositories to see if Heroku added support already:

- <https://github.com/heroku/heroku-buildpack-nodejs>
- <https://github.com/heroku/heroku-buildpack-ruby>

## Automatic merging

To speed up the merging of smaller upgrades (like security fixes) we enable
Automatic merging like this:

![Depfu Automatic Merging](../images/depfu_automatic_merging.png)

Since PRs need to be approved before depfu can merge them we add a GitHub
Actions workflow to automatically approve PRs from depfu:

```yaml
# .github/workflows/depfu_autoapprove.yml
name: Depfu auto-approve
on:
  pull_request_target:
    types: [opened]

permissions:
  pull-requests: write

jobs:
  depfu:
    runs-on: ubuntu-latest
    if: ${{ github.actor == 'depfu[bot]' }}
    steps:
      - name: Approve all depfu PRs
        run: gh pr review --approve "$PR_URL"
        env:
          PR_URL: ${{github.event.pull_request.html_url}}
          GITHUB_TOKEN: ${{secrets.GITHUB_TOKEN}}
```

## Ticket reference

In order to avoid searching for the maintenance project after reviewing a Depfu PR,
we add the ticket to the PR title according to the following Depfu configuration:

![Depfu Redmine Ticket PR Title](../images/depfu_pr_title.png)

Make sure that the ticket number matches the actual maintenance ticket.
