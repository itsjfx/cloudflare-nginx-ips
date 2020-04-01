# cloudflare-nginx-ips
A script to handle automated IP grabbing from nginx which allows it to setup real ips and setup ufw rules for only cloudflare traffic or setup site cloudflare whitelists for nginx

## Why
Stops your site leaking outsite of cloudflare, increasing your security by stopping people from finding your sites origin IP.

It also sets up the real IP module for nginx which is useful for getting the real IPs of users instead of cloudflares IPs.

## Real ips
The script will handle the real ips generation and setting for you so you can see your visitors real ips

## ufw rules (recommended)
The script can add ufw rules for cloudflare ips to only allow them on ports 443, 80. This mode can be disabled however, and selective geo whitelists for sites can be used instead. This mode should ideally be on as your site might send an SSL certificate and other data that may help fingerprint your server... if there is no reason in your configuration to expose nginx without cloudflare, then why do it.

**Despite being recommended, ufw rule adding is off by default. to enable edit the script and set UFW_RULES to true**

## If you wish to only allow cloudflare IP's add this to your site block for each host (with ufw mode off)
```
if ($cloudflare_ip != 1) {
	return 403;
}
```

This will return a 403 to any visitor not from cloudflare, ideally you should enable ufw rules instead to not expose nginx, however a benefit of this is you can selectively choose which hosts are cloudflare only and which arent.

## Job
Run monthly (or whenever really) in a crontab
```
@monthly /bin/bash /etc/nginx/cloudflare-ips.sh
```