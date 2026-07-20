# Uptimerobot Monitoring

To ensure that our application is always up and running, we offer a monitoring
service to the customers.

When we are still developing a new application, the uptimerobot check should not be
setup to avoid premature costs. Once the go-live date is very close, we enable
the monitoring only for the `main` environment, which *must* have a paid
dyno.

## Setup

You will need Renuo-CLI to be set up and at the newest version:
`gem install renuo-cli` --> see [renuo-cli](https://github.com/renuo/renuo-cli)

1. Run the command `renuo setup-uptimerobot [url]`
   * Where `url` is the address you want to monitor. e.g. `https://[project-name]-main.renuoapp.ch/up` or `https://customdomain.ch/up`

1. The app will ask for the `api-key` for uptimerobot. It can be found at the companies' password manager.
    Paste it and press enter to continue.

The command will setup the project in a paused state. You can start it once your app has a paid dyno.

**Until then do not start the monitoring.**

## Examples

* `renuo setup-uptimerobot https://germann.ch/up`

## Replacing monitors

It's cumbersome to exchange a monitor for all projects.
You can utilize this script for that:

```rb
require "json"
require "open3"

API_KEY = "XXX"
OFFSET = 0 # default page size is 50

# Use Open3 to capture stdout and stderr to avoid shell-specific parsing issues
monitors_response, stderr, status = Open3.capture3("curl -X POST -H \"Content-Type: application/x-www-form-urlencoded\" -H \"Cache-Control: no-cache\" -d 'api_key=#{API_KEY}&format=json&alert_contacts=1&offset=#{OFFSET}' \"https://api.uptimerobot.com/v2/getMonitors\" | jq -c '[.monitors[] | {id: .id, alert_contacts: .alert_contacts}]'")

unless status.success?
  puts "Error executing command: #{stderr}"
  exit
end

monitors = JSON.parse(monitors_response)
monitors.each do |monitor|
  id = monitor["id"]

  # Add your new monitor here so that it is added to all projects
  monitor["alert_contacts"] << { "id" => raise("TODO: replace this"), "threshold" => 0, "recurrence" => 0 }

  alert_contacts = monitor["alert_contacts"].map { |contact|
    contact.values_at("id", "threshold", "recurrence").compact.join("_")
  }.join("-")

  cmd = %(curl -X POST -H "Cache-Control: no-cache" -H "Content-Type: application/x-www-form-urlencoded" -d 'api_key=#{API_KEY}&format=json&id=#{id}&alert_contacts=#{alert_contacts}' "https://api.uptimerobot.com/v2/editMonitor")
  puts cmd
end
```

## Slack Integration

In order to receive uptime messages on a project specific `-notifications` channel you need to:

* Add a webhook on the Uptimerobot Slack App: https://api.slack.com/apps/A06PKA5ENRJ/incoming-webhooks
  * You might have to request access as a collaborator first
* Configure the webhook in Uptimerobot https://dashboard.uptimerobot.com/integrations
* Add the channel integration on the monitor under `Edit` -> `Integrations & Team`
