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
1. Set up your ENV-variables and test if the mails are working. Manual test emails can be send via the following command in the rails console (production environment): `ActionMailer::Base.new.mail(to: 'yourname@renuo.ch', from: ENV['MAIL_SENDER'], subject: 'Testmail', body: 'Mail content').deliver!`
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

## Bounce Domain
### What is a bounce domain?

A bounce domain (also called a Return-Path domain, MAIL FROM domain, or envelope-from domain) is the domain designated to collect undeliverable message notifications (bounces). It is normally visible in the email's Return-Path header.

```text
From:           notifications@mail.renuo.ch
Return-Path:    something@bounce.renuo.ch
```

`From:` Shows the sender to the recipient.

`Return-Path:` Tells the receiving mail server where it should send the bounces.

When an email can't be delivered, the receiving mail server sends a bounce to the envelope sender.

### How it works

1. Your application sends an email through SparkPost.
2. The recipient's mail server tries to deliver the email.
3. If delivery fails, the mail server sends a bounce to the
   envelope sender (Return-Path).
4. The Return-Path uses your bounce domain.
5. SparkPost receives the bounce and records the delivery failure.

### Why is a bounce domain needed?

Bounce domains are useful for automated or high-volume email sending, such as newsletters or notifications.
Some emails will fail to be delivered because the recipient does not exist or their mailbox is full etc. The receiving
mail server sends these bounces to the `Return-Path`.

For further information visit [here](https://docs.sparkpost.com/docs/tech-resources/custom-bounce-domain/#setting-up-a-bounce-domain)

### Configuration

For a normal SparkPost setup, use a subdomain for the bounce domain:

```text
Sending domain:     mail.renuo.ch
Bounce domain:      bounce.renuo.ch
```

Do not use the root domain if it is also used for normal incoming email. Using a dedicated subdomain avoids interfering
with your existing email configuration.

### DNS records

SparkPost will provide a CNAME record that you need to add to your DNS provider.

### Verify bounce domain

1. In the domains tab, select Bounce Domains
2. Click "Add Bounce Domain"
3. Enter a subdomain instead of your root domain, click "Save and Continue"

> [!Warning]
> Use a dedicated **subdomain** for the bounce domain. The domain's mail handling is intended for SparkPost, so you
should **not** use a domain that you also need for normal incoming email.

1. Add the record name and value to your DNS provider
2. Select type CNAME and turn off the proxy. This prevents traffic from diverting to Cloudflare instead of the mail
   server
3. Click "save"
4. Go to the DNS page on SparkPost and click "Verify Domain".

### DNS authentication

#### SPF

Sender Policy Framework proves that an authorized server is allowed to send emails for your domain. In other
words, it says "This email came from a server my domain authorized to send mail."

#### DKIM

DomainKey Identified Mail allows owners to automatically sign emails from their domain. This proves the mail really came
from the domain.

#### DMARC

Domain-based Message Authentication Reporting and Conformance tells the receiving mail server what to do after checking
SPF and DKIM. For example marking the email as "spam", deliver it anyway or dropping it entirely.
