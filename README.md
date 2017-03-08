# DEVOPS TRAINING chef-repo

## Cookbooks

- base
	- attributes (workspace)
- docker-deploy
	- default (install docker packages)
	- server (configure and run registry and jenkins)
	- node (deploy web application)
- monitoring
	- server (install and configure InfluxDB, Grafana)
	- node (install and configure collectd)
- security
	- server (server certificates from data bag)
	- node (clien certificates from data bag)

## Roles

- builder
	- InfluxDB
	- Grafana
	- docker-registry
	- jenkins
	- chef-server
	- collecd
- node
	- docker with web application
	- collectd
