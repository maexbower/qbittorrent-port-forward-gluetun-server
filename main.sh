#!/bin/sh
set -e

qbt_username="${QBT_USERNAME:-admin}"
qbt_password="${QBT_PASSWORD:-adminadmin}"
qbt_addr="${QBT_ADDR:-http://localhost:8080}" # ex. http://10.0.1.48:8080
gtn_addr="${GTN_ADDR:-http://localhost:8000}" # ex. http://10.0.1.48:8000
# Gluetun Control Server auth is mandatory starting from Version 3.40.0
gtn_auth="${GTN_AUTH:-basic}" # Possible auth methods are "basic" and "api"
gtn_username="${GTN_USERNAME:-admin}" # Use only with "basic" auth
gtn_password="${GTN_PASSWORD:-admin}" # Use only with "basic" auth
gtn_apikey="${GTN_API_KEY:-123456789}" # Use only with "api" auth

gtn_authstring=""

# create auth string for CURL requests
if [ "$gtn_auth" = "basic" ]; then
    gtn_authstring="-u $gtn_username -p $gtn_password"
elif [ "$gtn_auth" = "api" ]; then
    gtn_authstring="-H "X-API-Key: $gtn_apikey"
else
    echo "Authentication Method for GlueTun set to an unknown parameter: $gtn_auth"
    exit 1
fi

port_number=$(curl --fail --silent --show-error $gtn_authstring $GTN_ADDR/v1/openvpn/portforwarded | jq '.port')
if [ ! "$port_number" ] || [ "$port_number" = "0" ]; then
    echo "Could not get current forwarded port from gluetun, exiting..."
    exit 1
fi

curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt --header "Referer: $qbt_addr" --data "username=$qbt_username" --data "password=$qbt_password" $qbt_addr/api/v2/auth/login 1> /dev/null

listen_port=$(curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt $qbt_addr/api/v2/app/preferences | jq '.listen_port')

if [ ! "$listen_port" ]; then
    echo "Could not get current listen port, exiting..."
    exit 1
fi

if [ "$port_number" = "$listen_port" ]; then
    echo "Port already set, exiting..."
    exit 0
fi

echo "Updating port to $port_number"

curl --fail --silent --show-error --cookie-jar /tmp/cookies.txt --cookie /tmp/cookies.txt --data-urlencode "json={\"listen_port\": $port_number}"  $qbt_addr/api/v2/app/setPreferences

echo "Successfully updated port"
