# Custom JMeter Dockerfile for Distributed Testing (No SSL)
FROM openjdk:11-jre-slim

ENV JMETER_VERSION=5.5
ENV JMETER_HOME=/opt/apache-jmeter-$JMETER_VERSION
ENV PATH=$JMETER_HOME/bin:$PATH

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Download and extract JMeter
RUN wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz && \
    tar -xzf apache-jmeter-$JMETER_VERSION.tgz -C /opt && \
    rm apache-jmeter-$JMETER_VERSION.tgz

# Disable SSL for RMI by default
ENV JMETER_JVM_ARGS="-Dserver.rmi.ssl.disable=true -Dclient.rmi.ssl.disable=true"

# Create folders for logs and results
RUN mkdir -p /mnt/jmeter/server /mnt/jmeter/client

WORKDIR /mnt/jmeter

# Entrypoint for master/slave
ENTRYPOINT ["jmeter"]

# Default command
CMD ["--help"]
