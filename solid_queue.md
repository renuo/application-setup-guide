# Solid Queue (single db)

Solid queue is a backend framework for active jobs that stores the queue in a db.

```yaml
# database.yml
development:
    primary:
        <<: *default
        database: [application_name]_development

```

Then run `db:prepare` and `bin/rails solid_queue:install`

```rb
# config/environments/production.rb && develoment.rb

# Use Solid Queue in Development.
config.active_job.queue_adapter = :solid_queue
config.solid_queue.connects_to = { database: { writing: :primary } }
```
```rb
# config/puma.rb

plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"] || Rails.env.development?
```
After this you will copy the contents from db/schema_queue.rb. It is important that you only copy the table creates.
Then generate an empty migration with `bin/rails generate migration SolidQueue` then paste into the change function the contents and execute `bin/rails db:migrate`
