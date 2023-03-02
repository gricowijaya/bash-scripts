#!/bin/bash

sed -i "s/$(echo -ne '\u200b')//g" ipv6.txt

IPV6ADDR=$(cat ipv6.txt);

echo $IPV6ADDR;

ipv6calc --addr2compaddr $(cat ipv6.txt)
