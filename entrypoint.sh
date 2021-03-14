#!/bin/bash

echo "Welcome to KeeWeb docker container!"

if [ -z ${DH_SIZE+x} ]
then
  >&2 echo ">> no \$DH_SIZE specified using default"
  DH_SIZE="512"
fi


DH="/etc/nginx/external/dh.pem"

if [ ! -e "$DH" ]
then
  echo ">> seems like the first start of nginx"
  echo ">> doing some preparations..."
  echo ""

  echo ">> generating $DH with size: $DH_SIZE"
  openssl dhparam -out "$DH" $DH_SIZE
fi

if [ ! -e "/etc/nginx/external/cert.pem" ] || [ ! -e "/etc/nginx/external/key.pem" ]
then
  echo ">> generating self signed cert"
  openssl req -x509 -newkey rsa:4086 \
  -subj "/C=XX/ST=XXXX/L=XXXX/O=XXXX/CN=localhost" \
  -keyout "/etc/nginx/external/key.pem" \
  -out "/etc/nginx/external/cert.pem" \
  -days 3650 -nodes -sha256
fi

if [ ${KEEWEB_CONFIG_URL} ]
then
  sed -i "s,(no-config),${KEEWEB_CONFIG_URL}," /keeweb/index.html
else
  sed -i "s,(no-config),config.json," /keeweb/index.html
fi

# adding WebDav Support
set -e

WEBDAV_USERNAME=${WEBDAV_USERNAME:-$(tr -cd [:alnum:] < /dev/urandom | fold -w20 | head -n1)}
WEBDAV_PASSWORD=${WEBDAV_PASSWORD:-$(tr -cd [:alnum:] < /dev/urandom | fold -w20 | head -n1)}

#htpasswd -cbB /etc/nginx/htpasswd.webdav "$WEBDAV_USERNAME" "$WEBDAV_PASSWORD" Tested, where Bcrypt no work on Debian but Alpine
htpasswd -cb /etc/nginx/htpasswd.webdav "$WEBDAV_USERNAME" "$WEBDAV_PASSWORD"

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"
