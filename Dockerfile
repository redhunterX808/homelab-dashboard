FROM alpine:latest

WORKDIR /app

CMD ["sh", "-c", "echo 'Application template container started' && sleep infinity"]
