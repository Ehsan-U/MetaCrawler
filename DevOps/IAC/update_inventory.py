

import sh
import json
from pprint import pprint



data = json.loads(sh.terraform("output", "-json"))
mapping = data.get('instance_public_ips')['value']


def extract_ip(raw_string):
	ip_cidr = raw_string.split(",")[0]
	return ip_cidr.replace("ip=",'').replace("/24",'')


servers = {
    "master": [extract_ip(ip) for category, ip in mapping.items() if 'master' in category],
    "slave": [extract_ip(ip) for category, ip in mapping.items() if 'slave' in category],
}

with open('../Management/inventory', 'w') as f:
    for group, addresses in servers.items():
        f.write(f'[{group}]\n')
        for address in addresses:
            f.write(f'{address}\n')
        f.write('\n')

