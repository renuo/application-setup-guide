# Renuo Application Setup Guide

This repo is the [Renuo](https://www.renuo.ch) collection of best-practices to set-up apps.
We are a [Rails company](https://rubyonrails.org/foundation), so the most value probably
will be found in the parts concerning Rails. But anyways you'll also find a lot about the
inner workings of Renuo.

* [Ruby on Rails – Application Setup Guide](./ruby_on_rails/README.md)

## Some Notes on the Side

If you are reading this document, it means that you have to setup a new application.
A new project started and it's now time to set everything up so that **everyone**,
in your team, **can start working on it**.

This document will try to be as minimalist as possible and provide you with all the steps to set up the application as
fast as possible. There are things, in Renuo projects, which are mandatory, other that are suggested.
This guide is the result of more than ten years of experience, so this means three things: it's very robust, very opinionated, and possibly very outdated.

**You are always welcome to challenge the guide and improve it with a Pull Request.**

The basic things that need to be ready before the team can start working on a project are:

* An existing *git* repository containing the project
* Two branches: *main* and *develop*
* A README with essential information about the application
* Convenience-scripts: `bin/setup`, `bin/check`, `bin/fastcheck`, `bin/run`
* One running, green test
* Continuous integration (*CI*) ready, running and green for both branches
* Continuous deployment (*CD*) ready and running for both branches
* The application deployed for both branches

As an appendix, you'll find a [checklist](checklist.md) you can use to follow the guide.

**:exclamation: Do not blindly follow this guide, always think about what you are doing and why.
If you think something is wrong or simply outdated, improve this guide with a Pull Request.**

We want you to know exactly the reason behind each single step of this guide.

Thank you for your work and have fun! :tada:

## Serving the Documentation Locally

To view this documentation on your machine, run the following commands:

```sh
brew install mdbook
mdbook serve
```

## License

[Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/legalcode)
