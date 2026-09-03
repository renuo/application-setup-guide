# BOUNCE DOMAIN
## What is a bounce domain?
A bounce domain is the domain used for the envelope sender. It is normally visible in the email's Return-Path header.
```text
From:           notifications@mail.renuo.ch
Return-Path:    something@bounce.renuo.ch    
```
`From:` Shows the sender to the recipient.

`Return-Path:` Tells the receiving mail server where it should send the bounces.

When an email can't be delivered, the receiving mail server sends a bounce to the envelope sender.

## How it works
1. Your application sends an email through SparkPost.
2. The recipient's mail server tries to deliver the email.
3. If delivery fails, the mail server sends a bounce to the
   envelope sender (Return-Path).
4. The Return-Path uses your bounce domain.
5. SparkPost receives the bounce and records the delivery failure.


## Why is a bounce domain needed?
Bounce domains are useful for automated or high-volume email sending, such as newsletters or notifications. 
Some emails will fail to be delivered because the recipient does not exist or their mailbox is full etc. The receiving 
mail server sends these bounces to the `Return-Path`.

When SparkPost sends an email, there are two sender addresses involved: the visible `From:` address and the SMTP 
envelope sender. The envelope sender is used for delivery notifications such as bounces. The bounce domain provides the 
domain for this envelope sender.

## Configuration
For a normal SparkPost setup, use a subdomain for the bounce domain: 
```text
Sending domain:     mail.renuo.ch
Bounce domain:      bounce.renuo.ch
```
Do not use the root domain if it is also used for normal incoming email. Using a dedicated subdomain avoids interfering 
with your existing email configuration.

## DNS records
SparkPost will provide a CNAME record that you need to add to your DNS provider. 

## Verify bounce domain
1. In the domains tab, select Bounce Domains
2. Click "Add Bounce Domain"
3. Enter a subdomain instead of your root domain, click "Save and Continue"
> [!Warning]
> Use a dedicated **subdomain** for the bounce domain. The domain's mail handling is intended for SparkPost, so you 
should **not** use a domain that you also need for normal incoming email.
4. Add the record name and value to your DNS provider
5. Select type CNAME and turn off the proxy. This prevents traffic from diverting to Cloudflare instead of the mail
   server
6. Click "save"
7. Go to the DNS page on SparkPost and click "Verify Domain".

## DNS authentication
### SPF
Sender Policy Framework proves that an authorized server is allowed to send emails for your domain. In other 
words, it says "This email came from a server my domain authorized to send mail."

### DKIM
DomainKey Identified Mail allows owners to automatically sign emails from their domain. This proves the mail really came 
from the domain.

### DMARC
Domain-based Message Authentication Reporting and Conformance tells the receiving mail server what to do after checking
SPF and DKIM. For example marking the email as "spam", deliver it anyway or dropping it entirely.

