# Dockerfile pour le déploiement de docker-compose sur Railway
FROM docker/compose:latest

WORKDIR /app

COPY docker-compose.yml .
COPY start-services.sh .

RUN chmod +x start-services.sh

# Pas de VOLUME - Railway gère les volumes via leur interface

CMD ["./start-services.sh"]