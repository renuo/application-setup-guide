# onlylogs

[onlylogs](https://github.com/renuo/onlylogs) is our tool to read and search application logs.

1. Create a project on [onlylogs.io](https://onlylogs.io) and copy the `ONLYLOGS_DRAIN_URL`.
2. If the PaaS in use supports log drains, you'll find instructions directly on the project page you just created.
1. Otherwise, set `ONLYLOGS_DRAIN_URL` as an ENV variable on the application server.
1. Replace the production logger:

```ruby
# config/environments/production.rb
config.logger = Onlylogs::HttpLogger.new
```

To keep a local copy of the logs as well (if you have a disk) pass a local fallback:

```ruby
log_file = Logger::LogDevice.new(
  Rails.root.join("log", "production.log"), shift_age: 5, shift_size: 100.megabytes
)
config.logger = Onlylogs::HttpLogger.new(local_fallback: log_file)
```

## Reducing noise

Health checks and asset requests can be dropped before they reach the log file:

```ruby
# config/environments/production.rb
config.logger = Onlylogs::Logger.new(Rails.root.join("log", "production.log"))
config.logger.formatter.denylist = [/health_check/, /ping/]
```
