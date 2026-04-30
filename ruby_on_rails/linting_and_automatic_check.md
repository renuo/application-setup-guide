# Linting and automatic checks ✅

All Renuo projects contain (and your project must contain as well) the following linters.
Every linter consists of a gem (usually) and a command to add to our `bin/fastcheck` script.

Check out the `bin/fastcheck` [fastcheck](../templates/bin/fastcheck) for the final version of it.

## Renuocop 👮

> ✨ Installed by the Renuo Rails template (replaces `rubocop-rails-omakase`).

> ✨ Installed by the Renuo Rails template (replaces `rubocop-rails-omakase`).

Renuocop is based on Standard Ruby and is a set of rules that we use to lint our Ruby code.

You can execute it and correct the issues you'll find.

`bundle exec rubocop -A` will fix ~~most~~ all of them automatically.

## Brakeman

> ✨ Ships with Rails 8.1 by default.

Add it to the `bin/fastcheck` script:

```sh
bundle exec brakeman -q -z --no-summary --no-pager
```

## Bundler-audit

> ✨ Ships with Rails 8.1 by default.

Scans `Gemfile.lock` for gems with known security vulnerabilities. Add it to the `bin/fastcheck` script:

```sh
bundle exec bundler-audit check --update
```

Use `config/bundler-audit.yml` to ignore specific advisories if needed.

## Mdl

An optional check for markdown files. You can include it or not. Discuss within your team.

```ruby
group :development, :test do
  gem 'mdl', require: false
end
```

## SCSS lint

> [!NOTE]
> Your Semaphore configuration might have to be adjusted if you decide to use `npm`.

To lint the SASS/SCSS files in our project you can use the `stylelint` npm package.

`npm install stylelint stylelint-config-standard-scss`

Add to the project the [linter configuration file](../templates/.stylelintrc.yml) and check the [`bin/fastcheck`
template](../templates/bin/fastcheck) to see the command to execute the SCSS linting.

## Linting against [caniuse](https://caniuse.com/)

You might want to check whether the JS/CSS you produce is working in your target browsers.
This can be done using the `browserslist` package and linter plugins.

### CSS (stylelint-no-unsupported-browser-features)

This plugin can either be configured directly (shown here) or use a global `browserslist` config (less flexible).

```sh
npm add -D browserslist stylelint stylelint-config-standard stylelint-no-unsupported-browser-features
```

```js title="stylelint.config.mjs"
// stylelint.config.mjs
export default {
  extends: ["stylelint-config-standard"],
  "plugins": [
    "stylelint-no-unsupported-browser-features"
  ],
  "rules": {
    "plugin/no-unsupported-browser-features": [
      true,
      {
        "browsers": [
          "chrome >= 112"
        ],
        "ignore": [
          "rem"
        ],
        "ignorePartialSupport": true
      }
    ]
  }
};
```

Assume the following CSS:

```css title="app/assets/stylesheets/application.css"
/* app/assets/stylesheets/application.css */
.layout {
  display: grid;
  grid-template-rows: auto 1fr auto;
  gap: 12px;
}

.panel {
  display: grid;
  grid-template-rows: subgrid;
  gap: 6px;
}
```

This would lead to the following linting error

```sh
$ node_modules/stylelint/bin/stylelint.mjs "**/*.css" -c /Users/josua/p/tmp/eslint/stylelint.config.mjs

app/assets/stylesheets/application.css
  20:3  ✖  Unexpected browser feature "css-subgrid" is not supported by Chrome 112-116  plugin/no-unsupported-browser-features

✖ 1 problem (1 error, 0 warnings)
```

### JS (eslint-plugin-compat)

This plugin can only be configured using a global `browserslist` as it seems.

```sh
npm add -D eslint @eslint/js eslint-plugin-compat
```

```js title="eslint.config.mjs"
// eslint.config.mjs
import js from "@eslint/js";
import compat from "eslint-plugin-compat";

export default [
  {
    files: ["**/*.js"],
    ...js.configs.recommended,
  },
  compat.configs["flat/recommended"],
];
```

## Erb lint

```ruby
group :development, :test do
  gem 'erb_lint', require: false
end
```

## ESLint

```
npm install eslint
npx eslint --init (Use a popular style guide -> Airbnb)
```

then extend the `bin/fastcheck` script with:

```
yarn eslint app/javascript
```

The templates folder contains a template for the eslint configuration.

## All Good!

Now your `bin/fastcheck` is not that fast anymore 😄
