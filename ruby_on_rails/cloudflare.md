# Cloudflare

In Cloudflare you will set up the DNS to you application in conjunction with deploio.

Setup Cloudflare: <https://www.cloudflare.com/a/dns/renuoapp.ch>

After the link you will have to set the Cname to your Deplo.io application.
In Deplo.io under hosts you will find the Cname target pasting that into your Cloudflare as the target you will have successfully created a domain.

* Now open
  * <http://[project-name]-main.renuoapp.ch/home/check>
  * <http://[project-name]-develop.renuoapp.ch/home/check>

Check that you:
* see "1+2=3" in each app.
* have been redirected to https.

## Crypto settings

When setting up a new site on Cloudflare, make sure you set SSL to "Full" under Crypto settings. You may end up in endless loop of redirects if it stays on the default setting ("Flexible")
