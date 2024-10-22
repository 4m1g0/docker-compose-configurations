#!/bin/sh

# Verifica si el paquete de Cloudflare ya está instalado
if ! caddy list-modules | grep -q 'dns.providers.cloudflare'; then
  echo "Installing Cloudflare DNS package..."
  caddy add-package github.com/caddy-dns/cloudflare
else
  echo "Cloudflare DNS package already installed."
fi

# Inicia Caddy
caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
