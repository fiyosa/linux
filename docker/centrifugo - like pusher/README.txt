docker run -d \
  --name centrifugo \
  -p 8002:8000 \
  -v $(pwd)/config.json:/centrifugo/config.json \
  --ulimit nofile=65535:65535 \
  centrifugo/centrifugo:v6 \
  centrifugo -c config.json

docker compose up -d --no-build

docker compose down --rmi all