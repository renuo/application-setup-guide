# SparkPost & Mailtrap

> [!WARNING]
> Always use subaccounts in Sparkpost! Otherwise there may be compliance issues which can lead to the closing down of the whole Renuo account.

## Introduction

**Main (Sparkpost, sample-app@yourdomain.tld)**

- Each app is using a separate subaccount under the main account
- The Domain should be set up and verified under the subaccount's sending domains
- Login: sparkpost+main@renuo.ch

**Develop (Sparkpost, renuoapp.ch)**

- Each app is using a separate subaccount under the main account
- The emails will be sent with **\*@renuoapp.ch** as your mail sender
- Login: sparkpost+develop@renuo.ch

- If you want, you can also use Mailtrap for develop. Create a new Inbox <https://mailtrap.io/inboxes> and use this credentials

**Testing (Mailtrap)**

- Login: operations@renuo.ch
- The Email will be caught by Mailtrap and not forwarded to the intended receiver
- You can login to Mailtrap to see the sent email

## Sparkpost

> [!WARNING]
> Always use subaccounts for the project, so that the whole account doesn't get suspended / blocked in case of compliance issues!

1. Go to <https://app.sparkpost.com/auth> and log in with the credentials for
   sparkpost+_enviroment_@renuo.ch found in the credential store
1. Create [one new subaccount](https://app.sparkpost.com/account/subaccounts) and name it like your project
1. Create [a new API-Key for your subaccount](https://app.sparkpost.com/account/api-keys/create) and assign it to the new subaccount, with the following permissions: *Send via SMTP, Sending Domains: Read/Write*
1. Write down the API-key in the credential store (in a list under sparkpost+_enviroment_@renuo.ch), because it's only showed once!
1. Credentials for SMTP setup on your app can be found [here](https://app.sparkpost.com/account/smtp), password is your generated API-key
1. (if domain is known) Add your sending domain
   [here](https://app.sparkpost.com/domains/create?type=sending). Assign it to
   the subaccount. Set up SPF, DKIM and DMARC with TXT DNS records (only use
   `renuoapp.ch` within the `sparkpost+develop@renuo.ch`)
1. Verify your Email DNS configuration with <https://mxtoolbox.com/SuperTool.aspx>
1. Set up your ENV-variables and test if the mails are working. Manual test emails can be send via the following command in the rails console (production environment): `ActionMailer::Base.mail(to: 'yourname@renuo.ch', from: ENV['MAIL_SENDER'], subject: 'Testmail', body: 'Mail content').deliver_now!`
1. Send a test email to <https://www.mail-tester.com/> or <https://www.experte.com/spam-checker> and check the result

For DNS setup also see [Go Live](go_live.md)

ENV-variables example:

```
MAIL_USERNAME: 'SMTP_Injection'
MAIL_PASSWORD:  'YOUR API KEY'
MAIL_HOST: 'smtp.sparkpostmail.com'
MAIL_SENDER: 'Sample App <sample-app@renuoapp.ch>'
```

Or with a custom domain:

```
MAIL_SENDER: 'Sample App <sample-app@yourdomain.tld>'
```

## Mailtrap

ENV-variables example:

```
MAIL_USERNAME: 'found in credential store'
MAIL_PASSWORD:  'found in credential store'
MAIL_HOST: 'smtp.mailtrap.io'
MAIL_SENDER: 'Sample App <sample-app@yourdomain.tld>'
```

Set up your ENV-variables and test if the mails are working. Manual test emails can be send via the following command in the rails console (production environment): `ActionMailer::Base.mail(to: 'yourname@renuo.ch', from: ENV['MAIL_SENDER'], subject: 'Testmail', body: 'Mail content').deliver_now!`
