# cloudflare-nginx-ips

a script to handle automated IP grabbing from nginx and setup real ips and cloudflare whitelist for nginx

## if you wish to only allow cloudflare IP's add this to your site block for each host
```
if ($cloudflare_ip != 1) {
	return 403;
}
```

this will return a 403 to any visitor not from cloudflare, ideally you should add a ufw or firewall rule to do this instead to not expose nginx, however a benefit of this is you can selectively choose which hosts are cloudflare only and which arent

## job
run monthly in a crontab @monthly /bin/bash /etc/nginx/cloudflare-ips.sh