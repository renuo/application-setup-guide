# Slack and Notifications

If you want to keep your team up-to-date with some notifications about the project and to discuss project-related topics
we suggest you to use [Slack](https://renuo.slack.com/).

You are, for sure, already a member of slack.

## Project Channel

You can create a project-dedicated channel on slack naming it `#project-[project-name]` (e.g. `#project-bookshelf`,
`#project-gifcoins`, etc..).

Invite all team members involved in the project to the channel.

## Deploy Notifications

One notification you may want to receive on this channel is about when a new deployment on main has been performed. In
order to do that you must be an admin of the Renuo Slack Organisation. If you are not an admin, ask wg-operations to do
it for you communicating the `[project-name]`.

> :warning: **You must have already setup [Automatic Deployment through SemaphoreCI](ruby_on_rails/configure_ci.md).**

If you used Renuo CLI to configure SemaphoreCI, the notifications should be already created. For manual setup, follow these steps:

1. Open the global Notifications settings (`https://renuo.semaphoreci.com/notifications`)
1. Create New Notification
1. Name of the Notification -> `[project-name]`

Add the following rules:

**deployment notifications**
1. Name of the Rule -> `deployment notifications`
1. Branches -> `main,develop`
1. Pipelines -> `/.*-deploy.yml/`
1. Slack Endpoint: Use the Webhook URL from other projects
1. Send to Slack channel: `#project-[project-name]-notifications`

**build notifications**
1. Name of the Rule -> `deployment notifications`
1. Branches -> `main,develop`
1. Pipelines -> `semaphore.yml`
1. Results -> `failed`
1. Slack Endpoint: Use the Webhook URL from other projects
1. Send to Slack channel: `#project-[project-name]-notifications`
