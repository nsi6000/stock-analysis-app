
cd ../../kafka

echo -e 'Dummy test.' | bin/kafka-console-producer.sh --topic quickstart-events --bootstrap-server localhost:9092


