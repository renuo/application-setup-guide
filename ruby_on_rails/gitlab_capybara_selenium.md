# Capybara and Selenium on Gitlab

Sometime our customers use Gitlab.
Even though documentation on this combination is scarce,
we still want to run our browser tests.

Here's an example configuration customizing the Capybara driver for remote Selenium:

```yaml
# .gitlab-ci.yml

test:system:
  stage: test
  services:
    - postgres:latest
    - selenium/standalone-chrome:latest # <-- THIS
  variables:
    POSTGRES_PASSWORD: postgres
    DATABASE_URL: postgresql://postgres:postgres@postgres:5432/example_test
    SELENIUM_REMOTE_URL: http://selenium-standalone-chrome:4444  # <-- THIS
  script:
    - bin/rails db:prepare
    - bin/check_system
  artifacts:
    paths:
      - tmp/screenshots/
```

```rb
# spec/rails_helper.rb

RSpec.configure do |config|
  config.before(:each, :js, type: :system) do
    if ENV["CI"]
      net = Socket.ip_address_list.detect(&:ipv4_private?)
      ip = net.nil? ? "localhost" : net.ip_address

      Capybara.server_port = 8200
      Capybara.server_host = ip

      driven_by :selenium, using: :chrome, options: {
        browser: :remote,
        url: ENV.fetch("SELENIUM_REMOTE_URL"),
        options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu no-sandbox
                                                                   disable-dev-shm-usage
                                                                   force-prefers-reduced-motion])
      }
    else
      driven_by :selenium, using: ENV.fetch("SELENIUM_DRIVER", "headless_chrome").to_sym do |options|
        options.add_argument("--force-prefers-reduced-motion")
      end
    end
  end

  # WebMock catches everything per default, we allow localhost for Capybara/Selenium
  WebMock.disable_net_connect!(
    allow_localhost: true,
    allow: lambda { |uri|
      uri.host.include?(Capybara.server_host) ||
        uri.host.include?("selenium-standalone-chrome") # Allow Selenium Grid in CI
    }
  )
end
```
