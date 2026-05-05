# VCR

VCR is a gem for recording HTTP requests to external services and replaying them.
A VCR setup should be very specifically tied to the tests which need VCR because it's quite expensive.

Here's an example configuration we use at Renuo:

```rb
# spec/rails_helper.rb

RSpec.configure do |config|
  # …

  # Disable VCR completely for tests that are not tagged with :vcr
  config.around do |example|
    if example.metadata[:vcr]
      example.run
    else
      VCR.turned_off { example.run }
    end
  end
end

# WebMock catches everything per default, we allow localhost for Capybara/Selenium
WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |c|
  c.configure_rspec_metadata!
  c.debug_logger = $stderr if ENV['DEBUG'] == 'true'

  c.hook_into :webmock
  c.ignore_localhost = true

  c.cassette_library_dir = 'spec/vcr'
  c.default_cassette_options = {
    decode_compressed_response: true,
    allow_unused_http_interactions: false,
    record: ENV['VCR'] ? ENV['VCR'].to_sym : :once, # re-record with VCR=all
    drop_unused_requests: true # only when re-recording
  }

  # Filter out sensitive data from the cassettes
  env_keys = Dotenv.parse(".env.example").keys
  env_keys.each { |key| c.filter_sensitive_data("<#{key}>") { ENV.fetch(key, nil) } }
end
```

Some considerations:
* Do you really want/need VCR? A fake may be better: <https://thoughtbot.com/blog/how-to-stub-external-services-in-tests#create-a-fake-hello-sinatra>
* Do you test so specifically that WebMock would be the better tool?
* Does your project have special needs for tweaks: <https://blog.arkency.com/3-tips-to-tune-your-vcr-in-tests/>
* How often do you want to re-record your cassettes? Out-of-date replays may give you a false sense of safety.
* Where do you want to re-record your cassettes? Maybe nightly on the CI?

