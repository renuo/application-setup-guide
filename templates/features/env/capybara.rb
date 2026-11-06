# Reduced motion turns off smooth scrolling (e.g. Bootstrap), with which chromedriver waits about a second before
# every click on an element below the fold. It also makes CSS transitions instant.
Capybara.register_driver :headless_chrome_reduced_motion do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[headless=new force-prefers-reduced-motion])
  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :headless_chrome_reduced_motion
