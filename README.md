# Autopilot Pattern RabbitMQ

[Autopilot Pattern](http://autopilotpattern.io/) setup for RabbitMQ. The current version only registers RabbitMQ to a Consul server and performs health checks. The clustering is not taken into account at this stage.

## Usage

```
docker container run -e "LOG_LEVEL=debug" -e "CONSUL=CONSUL_HOST" -p "5672:5672" autopilotpattern/rabbitmq
```

### Environment Variables

- CONSUL: IP/HOSTNAME of the Consul host
- LOG_LEVEL: ContainerPilot log level, defaults to 'info'

### TODO

- [ ] Add cluster support
