#!/bin/bash -xe
apt-get update -y
apt-get install -y docker.io docker-compose

systemctl enable docker
systemctl start docker

mkdir -p /opt/elk
cd /opt/elk

# --- Create docker-compose.yml ---
cat <<EOF > docker-compose.yml
version: '3'
services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.17.10
    container_name: elasticsearch
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"
    networks:
      - elk

  logstash:
    image: docker.elastic.co/logstash/logstash:7.17.10
    container_name: logstash
    ports:
      - "5044:5044"
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    depends_on:
      - elasticsearch
    networks:
      - elk

  kibana:
    image: docker.elastic.co/kibana/kibana:7.17.10
    container_name: kibana
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    networks:
      - elk

networks:
  elk:
    driver: bridge
EOF

# --- Logstash Config ---
cat <<EOF > logstash.conf
input {
  stdin {}
}

output {
  elasticsearch {
    hosts => ["http://elasticsearch:9200"]
  }
  stdout { codec => rubydebug }
}
EOF

sleep 30
docker-compose up -d
