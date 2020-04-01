# cloudflare-nginx-ips
a script to handle automated IP grabbing from nginx and setup real ips and cloudflare whitelist for nginx

## real ips
the script will handle the real ips generation and setting for you so you can see your visitors real ips

## ufw rules (recommended)
the scripts can add ufw rules for cloudflare ips to only allow them on ports 443, 80. this mode can be disabled and selective geo whitelists for sites can be used instead. this mode should be on however as your site might send an SSL certificate and other data that may help fingerprint your server... if there is no reason in your configuration to expose nginx without cloudflare, then why do it.

**despite being recommended, ufw rule adding is off by default. to enable edit the script and set UFW_RULES to true**

## if you wish to only allow cloudflare IP's add this to your site block for each host (with ufw mode off)
```
if ($cloudflare_ip != 1) {
	return 403;
}
```

this will return a 403 to any visitor not from cloudflare, ideally you should enable ufw rules instead to not expose nginx, however a benefit of this is you can selectively choose which hosts are cloudflare only and which arent

## job
run monthly in a crontab
```
@monthly /bin/bash /etc/nginx/cloudflare-ips.sh
```