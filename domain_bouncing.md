DOMAIN BOUNCING

A bouncing domain is a domain which is linked in the MAIL FROM part of
an email. So that any outgoing email which fail know where to return to
they have a MAIL FROM which by default is set to the sender. With a 
bouncing domain any failed Emails will be sent to that secondary Email.

A bouncing domain is needed when you have a big automated mail sender. 
As an example if you create a newsletter this might reach a lot of
invalid Emails. This will cause each of those Emails to bounce. in those
cases it might be annoying if your mail sender get filled up with
bouncing mails. A bouncing domain will redirect all bouncing mail to
itself, and you can keep track more easily of what happened to that
bounced mail.

Important to configure:

    The bouncing domain will need an SPF record as to prevent spoofing.

    A public DKIM key created by your SPF to sign outgoing Emails

    A DMARC record to tell receiving Servers to reject Mails that fail the 
    top two checks.
