# Object Storage

## Deploio

### Command generation

The following command will generate command-line-commands to set up object storage on Deploio.
You'll need to run them by yourself after reviewing the output.

1. Run `renuo create-deploio-object-storage`
1. Follow the steps and answer the questions
1. Now it will print you out a series of commands e.g.:

   ```sh
   # Deploio main

       nctl create bucketuser main --project <<your-project>> --location <<location>>
       [...]
       nctl get bucketuser main --project <<your-project>> --print-credentials
       [...]

   # Deploio develop
   [...]
   ```
1. Review the commands carefully (e.g. make sure that you enable bucket versioning for the main branch)

If you think that the script is outdated, please open a Pull Request on the [renuo-cli](https://github.com/renuo/renuo-cli) project.

For further configuration and best practices, please refer to the [Deploio documentation](https://guides.deplo.io/ruby/object-storage.html#setup-object-storage).

## AWS

The following Amazon services are involved in our app setups

* Amazon **S3** is Amazon's Simple Cloud Storage Service,
  and used in most of your projects to store images and files.
* Amazon **CloudFront** is a large scale, global, and feature rich CDN.
  We mostly use it together with S3 to provide a proper HTTP endpoint (caching, header forwarding, etc.).
  You could also host a Single Page Application (SPA).
* Amazon **ACM** issues certificates which can be used for custom Cloudfront distribution domains
* Amazon **IAM** issues resource policies.
  * We use a special "renuo-app-setup" user to setup our projects.
  * Each app has an own user to separate tenants properly. The user belongs to "renuo-apps-v2"
  * You can find a graphical overview in [this lightning talk](https://docs.google.com/presentation/d/1E-6hQB7ZezsVlkESEQVJmdZtdTUWRalT8XjkriurIQc/edit#slide=id.g3ba9e981d1_0_7).

## Setup

### Preconditions

#### renuo-cli

You will need Renuo-CLI to be set up and at the newest version:

`gem install renuo-cli` → see [renuo-cli](https://github.com/renuo/renuo-cli)

Make sure `renuo -v` shows the [newest version](https://github.com/renuo/renuo-cli/tags)

#### aws-cli

Retrieve the credentials "AWS Profile 'renuo-app-setup' for s3 setup" from the password manager at first (or ask _wg-operations_ for help).

You'll need to use `aws-cli`. You can either just continue with "Start the Setup". The command will ensure that everything is set up properly.
Or you can install it manually:

```
brew install awscli
aws configure --profile renuo-app-setup
```

If you want to check your config, run `aws configure --profile renuo-app-setup list`.

We would recommend setting default region name to `eu-central-1`. The default output format is json and should not be changed.

### AWS Command generation

The following command will generate command-line-commands to set up S3 and CloudFront.
You'll need to run them by yourself after reviewing the output.

1. Run `renuo create-aws-project`
1. Follow the steps and answer the questions
1. Now it will print you out a series of commands e.g.:

   ```sh
   # AWS main

       aws --profile renuo-app-setup iam create-user --user-name <<your-project>>
       [...]

   # AWS develop
   [...]
   ```
1. Review the commands carefully (e.g. make sure that you enable bucket versioning)

### Executing the commands

Running the commands will print some JSON pages to your screen.
**Copy each `SecretAccessKey` and `AccessKeyId` to your credentials store!**

Once you have worked through the commands, you are ready to use S3 for Active Storage within your Rails app by configuring the storage.yml file (as below) and setting `config.active_storage.service = :amazon` in your production.rb file.

### Custom Cloudfront Distribution CNAME Aliases

If you want to serve your S3 bucket via a custom domain, you need to add the CNAMEs to
your Cloudfront Distibution manually.

1. Visit <https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=eu-central-1#/distributions> and edit
   your distribution.
1. Enter the CNAMEs as aliases
1. Click "Request certificate" (this opens a new tab with Amazon ACM, make sure it's region is us-east-1)
1. Enter all the CNAMEs you want to have as aliases (normally only one)
1. Enter the domain ownership verification records into Cloudflare (CNAME with cryptic values)
1. Submit the ACM form and wait for the certificate to being issued.
1. Go back to the Cloudfront distribution, refresh the certifactes drop down and choose your new certificate.
1. Save the changes to the Cloudfront distribution.

### Rails Configuration

You then can use an _ActiveStorage_ configuration like this:

```yaml
amazon:
  service: S3
  access_key_id: <%= ENV['AWS_S3_ACCESS_KEY_ID'] %>
  secret_access_key: <%= ENV['AWS_S3_SECRET_ACCESS_KEY'] %>
  bucket: <%= ENV['AWS_S3_BUCKET'] %>
  region: "eu-central-1"
```
