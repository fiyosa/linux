# start
docker compose -f sqlite.compose.yaml --env-file compose.env up -d

# stop & remove
docker compose -f sqlite.compose.yaml --env-file compose.env down

# if error: "Cannot read properties of undefined (reading 'replace')"
# just wait a few seconds and reload page (ctrl + shift + r)