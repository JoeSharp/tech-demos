# Proxy Demo
This project is intended to demo HTTP & HTTPS forward proxying.

It appears that nginx is only capable of HTTP proxy
HTTPS requires something more specialised, such as Squid

The docker compose file stands up
* An nginx http proxy
* A squid http(s) proxy (still trying to get that to work)
* An nginx local server that can be used as a test resource

The proxy-demo/ contains a spring boot app that provides a REST API
which will try and make a proxied call to the nginx local server.

This should demonstrate how to setup a proxy with Spring Boot REST Client
