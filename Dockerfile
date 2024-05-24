# Rename file to simply 'Dockerfile'.
# On Debian, apt-get install podman.
# podman build -t dev .
FROM debian:latest as base

WORKDIR /home/

RUN apt-get update
RUN apt-get install -y wget


FROM base as spark

ENV SPARK_VERSION=3.5.1
ENV HADOOP_VERSION=3
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark
RUN rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz


FROM base as kafka

ENV KAFKA_VERSION=3.7.0
ENV SCALA_VERSION=2.13
RUN wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
RUN tar -xvzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz
RUN mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} kafka
RUN rm kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz


FROM base

COPY ./Dockerfile .

COPY --from=spark /home/spark /home/spark
COPY --from=kafka /home/kafka /home/kafka

RUN apt-get install -y bash
RUN apt-get install -y vim
RUN apt-get install -y git

RUN apt-get install -y openjdk-17-jdk
RUN apt-get install -y maven

RUN git clone https://github.com/nsi6000/stock-analysis-app.git app/

EXPOSE 4040
EXPOSE 8080







