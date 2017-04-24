FROM rabbitmq:3.6.9-management-alpine

RUN apk update && apk add curl unzip

# Install consul
RUN export CONSUL_VERSION=0.8.0 \
    && CONSUL_CHECKSUM=f4051c2cab9220be3c0ca22054ee4233f1396c7138ffd97a38ffbcea44377f47 \
    && curl --retry 7 --fail -vo /tmp/consul.zip "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip" \
    && echo "${CONSUL_CHECKSUM}  /tmp/consul.zip" | sha256sum -c \
    && unzip /tmp/consul -d /usr/local/bin \
    && rm /tmp/consul.zip \
    && mkdir -p /opt/consul/config

# Add ContainerPilot and set its configuration file path
RUN export CONTAINERPILOT_VER=2.7.2 \
    && export CONTAINERPILOT_CHECKSUM=e886899467ced6d7c76027d58c7f7554c2fb2bcc \
    && curl -Lso /tmp/containerpilot.tar.gz \
        "https://github.com/joyent/containerpilot/releases/download/${CONTAINERPILOT_VER}/containerpilot-${CONTAINERPILOT_VER}.tar.gz" \
    && echo "${CONTAINERPILOT_CHECKSUM}  /tmp/containerpilot.tar.gz" | sha1sum -c \
    && tar zxf /tmp/containerpilot.tar.gz -C /usr/local/bin \
    && rm /tmp/containerpilot.tar.gz

# COPY ContainerPilot configuration
ENV CONTAINERPILOT_PATH=/etc/containerpilot.json
COPY etc/containerpilot.json ${CONTAINERPILOT_PATH}
ENV CONTAINERPILOT=file://${CONTAINERPILOT_PATH}

# COPY RabbitMQ's wrapper
COPY bin/wrapper.sh /usr/local/bin

# Override the parent entrypoint
ENTRYPOINT ["containerpilot"]
CMD ["wrapper.sh", "rabbitmq-server"]
