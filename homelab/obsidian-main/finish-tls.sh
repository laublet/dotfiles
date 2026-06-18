#!/usr/bin/env bash
# Run on uruk after Gandi DNS A record propagates.
set -euo pipefail

PROXY=~/homelab/proxy
DOMAIN=obsidian-main.loicaublet.fr

docker run --rm \
  -v "$PROXY/certbot/www:/var/www/certbot" \
  -v "$PROXY/certbot/conf:/etc/letsencrypt" \
  certbot/certbot:latest certonly --webroot -w /var/www/certbot \
  -d "$DOMAIN" --non-interactive --agree-tos

cp ~/homelab/obsidian-main/nginx/obsidian-main.loicaublet.fr.conf \
  "$PROXY/nginx/conf.d/obsidian-main.conf"

docker exec nginx nginx -t
cd "$PROXY" && docker compose restart nginx

echo "OK: https://$DOMAIN/vault/_utils"
