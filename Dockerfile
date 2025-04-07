FROM docker/compose:latest

WORKDIR /app

COPY docker-compose.yml .
COPY start-services.sh .

RUN chmod +x start-services.sh

CMD ["./start-services.sh"]