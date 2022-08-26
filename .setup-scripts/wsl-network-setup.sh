#!/usr/bin/env bash

## Get host machine ip from original resolv.conf
echo "Grep original nameserver/host machine IP"
ORIGINAL_NS=$(grep "nameserver" /etc/resolv.conf)

## Update wsl.conf to not generate the resolv.conf file
echo "Writing wsl.conf..."
echo "[network]" | tee -a /etc/wsl.conf
echo "generateResolvConf=false" | tee -a /etc/wsl.conf

## unlink resolv.conf file from wsl generated one
echo "Unlinking resolv.conf..."
unlink /etc/resolv.conf

## add new nameservers to resolv.conf
echo "Writing new resolv.conf..."
echo "nameserver 1.1.1.1" | tee -a /etc/resolv.conf # add external nameserver first to speed up internet connectivity
# (I noticed a significant improvement in respon time from the azure cli after switching the line with the next)
echo $ORIGINAL_NS | tee -a /etc/resolv.conf # add host ip as first argument
echo "nameserver 8.8.8.8" | tee -a /etc/resolv.conf

## make the resolv file immutable
# this is apparently the best solutions as mentioned in https://github.com/microsoft/WSL/issues/5420
echo "Making the resolv file immutable..."
chattr +i /etc/resolv.conf
