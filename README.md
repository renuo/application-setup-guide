# Renuo Application Setup Guide

This repo is the [Renuo](https://www.renuo.ch) collection of best-practices to set-up apps.
We are a [Rails company](https://rubyonrails.org/foundation), so the most value probably
will be found in the parts concerning Rails. But anyways you'll also find a lot about the
inner workings of Renuo.

If you are reading this document, it means that you have to setup a new application.
A new project started and it's now time to set everything up so that **everyone**,
in your team, **can start working on it**.

This document will try to be as minimalist as possible and provide you with all the steps to set up the application as
fast as possible. There are things, in Renuo projects, which are mandatory, other that are suggested.
This guide is the result of more than ten years of experience, so this means three things: it's very robust, very opinionated, and possibly very outdated.

**You are always welcome to challenge the guide and improve it with a Pull Request.**

**:exclamation: Do not blindly follow this guide, always think about what you are doing and why.
If you think something is wrong or simply outdated, improve this guide with a Pull Request.**

## How to Use This Guide

The guide is structured as a linear walkthrough. Follow it from top to bottom when setting up a new project.

1. **Before You Start** — Read [Naming Conventions](naming_conventions.md), [GitFlow](gitflow.md), and [Security](security.md) to understand the ground rules.
2. **Rails Application Setup** — Follow the [step-by-step setup](ruby_on_rails/README.md) to create, deploy, and configure your app.
3. **Guides & Recipes** — Pick the ones you need (emails, authentication, payment, etc.).
4. **Reference** — Use the [Checklist](checklist.md) to verify you haven't missed anything, and the [Go Live!](go_live.md) page when you're ready to launch.

## What Needs to Be Ready

Before the team can start working on a project, you need:

* An existing *git* repository containing the project
* Two branches: *main* and *develop* (or just *main* for internal projects)
* A README with essential information about the application
* Convenience-scripts: `bin/setup`, `bin/check`, `bin/fastcheck`, `bin/run`
* One running, green test
* Continuous integration (*CI*) ready, running and green for all branches
* Continuous deployment (*CD*) ready and running for all branches
* The application deployed for all branches

## Serving the Documentation Locally

To view this documentation on your machine, run the following command:

```sh
mdbook serve
```

## License

[Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/legalcode)
