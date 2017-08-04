FROM rabbitmq:3.6.9-management-alpine

RUN apk update && apk add curl unzip

# Add consul agent
RUN export CONSUL_VERSION=0.9.0 \
    && export CONSUL_CHECKSUM=33e54c7d9a93a8ce90fc87f74c7f787068b7a62092b7c55a945eea9939e8577f \
    && curl --retry 7 --fail -vo /tmp/consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip" \
    && echo "${CONSUL_CHECKSUM}  /tmp/consul.zip" | sha256sum -c \
    && unzip /tmp/consul -d /usr/local/bin \
    && rm /tmp/consul.zip \
    && mkdir /config

# Add ContainerPilot and set its configuration file path
ENV CONTAINERPILOT_VER 3.3.0
RUN export CONTAINERPILOT_CHECKSUM=62621712ef6ba755e24805f616096de13e2fd087 \
    && curl -Lso /tmp/containerpilot.tar.gz \
        "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VER}/containerpilot-${CONTAINERPILOT_VER}.tar.gz" \
    && echo "${CONTAINERPILOT_CHECKSUM}  /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /usr/local/bin \
    && rm /tmp/containerpilot.tar.gz

# COPY ContainerPilot configuration
COPY etc/containerpilot.json5 /etc/containerpilot.json5
ENV CONTAINERPILOT /etc/containerpilot.json5

# COPY RabbitMQ's wrapper
COPY bin/wrapper.sh /usr/local/bin

# Override the parent entrypoint
ENTRYPOINT ["containerpilot"]
