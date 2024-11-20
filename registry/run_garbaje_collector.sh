# Set registry in read-only mode
READONLY=true docker compose up -d

# Run garbage collector
docker exec registry bin/registry garbage-collect /etc/docker/registry/config.yml

# Set registry in normal mode again
docker compose up -d
