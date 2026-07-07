# Content Security Policy

By default, the Content Security Policy (CSP) should be enabled in every new project,
since it is an added layer of security that helps in detecting and mitigating attacks,
such as Cross Site Scripting (XSS) or Data Injection Attacks.

It works by telling the browser which sources are trustworthy. Everything that does not
come from a trusted source is blocked and a violation is reported to the report-uri (You
can also opt-in for reporting only. However, this is not recommended since it is not
effective when it comes to actually preventing an attack. One possible scenario, where
reporting only would be useful would be, when CSP should be introduced to a new project,
but blocking would possibly cause the site to malfunction).

## Setup

Content Security Policy can be enabled by uncommenting the code given in
`config/initializers/content_security_policy.rb`. This file has the following structure
after configuration:

```ruby
Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src    :self, :https, ...
  policy.img_src     ...
  policy.object_src  ...
  policy.script_src  ...
  policy.style_src   ...
  policy.connect_src :self, :https, 'http://localhost:3035', 'ws://localhost:3035' if Rails.env.development?
  policy.connect_src :self, :https if Rails.env.production?

  policy.report_uri ENV['CSP_REPORT_URI'] if ENV['CSP_REPORT_URI']
end
```

Details on how to setup Sentry reporting can be found in the [Sentry guide](https://github.com/renuo/application-setup-guide/blob/main/ruby_on_rails/sentry.md#backend-rails).

## Common Rules

**Warning:** This list may be incomplete. Please feel free to modify or add if you see something missing!

### Sentry

| Source      | Rule                                           |
| ----------- | ---------------------------------------------- |
| connect-src | `https://sentry.io`                            |
| script-src  | `https://cdn.ravenjs.com` (if loaded from CDN) |

### Google Tag Manager

| Source     | Rule                        |
| ---------- | --------------------------- |
| script-src | `'nonce-{generated_nonce}'` |
| img-src    | `www.googletagmanager.com`  |

Where the tracking script looks like:

```html
<script nonce="{generated_nonce}"><!-- Google Tag Manager Tracking Code --></script>
```

Alternatively, if `'unsafe-inline'` is already set, the nonce can be left out.

Starting from Rails 6 on, the `javascript_tag` view helper also accepts a nonce option:

```erbruby
<%= javascript_tag nonce: true do %>
  // code
<% end %>
```

#### With Preview Mode Enabled

| Source     | Rule                                                         |
| ---------- | ------------------------------------------------------------ |
| script-src | `https://tagmanager.google.com`                              |
| style-src  | `https://tagmanager.google.com https://fonts.googleapis.com` |
| img-src    | `https://ssl.gstatic.com https://www.gstatic.com`            |
| font-src   | `https://fonts.gstatic.com data:`                            |

#### Universal Analytics (Google Analytics)

| Source      | Rule                                                                |
| ----------- | ------------------------------------------------------------------- |
| script-src  | `https://www.google-analytics.com https://ssl.google-analytics.com` |
| img-src     | `https://www.google-analytics.com`                                  |
| connect-src | `https://www.google-analytics.com`                                  |

For a more details list, see <https://developers.google.com/tag-manager/web/csp>.

### Facebook Tracking Pixel

| Source     | Rule                                   |
| ---------- | -------------------------------------- |
| script-src | `'unsafe-inline' connect.facebook.net` |

### Google Fonts

| Source    | Rule                           |
| --------- | ------------------------------ |
| style-src | `https://fonts.googleapis.com` |

### Stripe

#### Checkout

| Source      | Rule                                       |
| ----------- | ------------------------------------------ |
| connect-src | `https://checkout.stripe.com g.stripe.com` |
| frame-src   | `https://checkout.stripe.com`              |
| script-src  | `https://checkout.stripe.com`              |
| img-src     | `https://*.stripe.com`                     |

#### Stripe.js

| Source      | Rule                                             |
| ----------- | ------------------------------------------------ |
| connect-src | `https://api.stripe.com`                         |
| frame-src   | `https://js.stripe.com https://hooks.stripe.com` |
| script-src  | `https://js.stripe.com`                          |

### Aiaibot

| Source      | Rule                                                 |
| ----------- | ---------------------------------------------------- |
| connect-src | `https://api.aiaibot.com https://sentry.aiaibot.com` |
