#!/bin/bash

CLOUDFLARE_REAL_IPS_PATH=/etc/nginx/conf.d/cloudflare_real_ips.conf
CLOUDFLARE_WHITELIST_PATH=/etc/nginx/conf.d/cloudflare_whitelist.conf

UFW_RULES=false

set -e

for file in $CLOUDFLARE_REAL_IPS_PATH $CLOUDFLARE_WHITELIST_PATH; do
	echo "# https://www.cloudflare.com/ips" > $file
	echo "# Generated at $(LC_ALL=C date)" >> $file
done

echo "geo \$realip_remote_addr \$cloudflare_ip {
	default 0;" >> $CLOUDFLARE_WHITELIST_PATH

for type in v4 v6; do
	echo "# IP$type"

	for ip in `curl https://www.cloudflare.com/ips-$type`; do
		echo "set_real_ip_from $ip;" >> $CLOUDFLARE_REAL_IPS_PATH;
		echo "	$ip 1;" >> $CLOUDFLARE_WHITELIST_PATH;
		if [ $UFW_RULES = true ] ; then
			ufw allow from $ip to any port www comment "cloudflare"
        	ufw allow from $ip to any port https comment "cloudflare"
		fi
	done
done

echo "}
# if you wish to only allow cloudflare IP's add this to your site block for each host:
#if (\$cloudflare_ip != 1) {
#	return 403;
#}" >> $CLOUDFLARE_WHITELIST_PATH
echo "real_ip_header X-Forwarded-For;" >> $CLOUDFLARE_REAL_IPS_PATH

nginx -t && systemctl reload nginx # test configuration and reload nginx

# cron job:
# @monthly /bin/bash /etc/nginx/cloudflare-ips.sh