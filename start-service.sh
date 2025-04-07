#!/bin/sh

echo "Démarrage des services Kafka et Zookeeper..."
docker-compose up -d

echo "Attente du démarrage de Zookeeper..."
until docker-compose exec -T zookeeper zkServer.sh status; do
  echo "Zookeeper n'est pas encore prêt - attente..."
  sleep 5
done

echo "Attente du démarrage de Kafka..."
until docker-compose exec -T kafka kafka-topics.sh --bootstrap-server localhost:9092 --list; do
  echo "Kafka n'est pas encore prêt - attente..."
  sleep 5
done

echo "Services démarrés avec succès!"

echo "Création des topics pour SUPMAP..."
docker-compose exec -T kafka kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic authentication-events --partitions 3 --replication-factor 1
docker-compose exec -T kafka kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic user-events --partitions 3 --replication-factor 1
docker-compose exec -T kafka kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic notification-events --partitions 3 --replication-factor 1
docker-compose exec -T kafka kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic map-events --partitions 3 --replication-factor 1
docker-compose exec -T kafka kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic incident-events --partitions 3 --replication-factor 1
docker-compose exec -T kafka kafka-topics.sh --bootstrap-server localhost:9092 --create --if-not-exists --topic contact-events --partitions 3 --replication-factor 1

echo "Configuration terminée! Kafka est accessible via:"
echo "Bootstrap Servers: kafka:9092, ${KAFKA_ADVERTISED_HOST}:29092"
echo "Kafka UI: http://localhost:8080"

tail -f /dev/null