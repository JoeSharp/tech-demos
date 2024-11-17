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

## So far

It's all held together with duct tape but as it stands

```bash
# Just bring up the web server
docker compose up ratracejoe
```

Ensure you have squid running on your actual VM (haven't quite dockerized it yet)

Run up the gradle application
```bash
cd proxy-demo

./gradlew bootRun
```

If you then tail the squid log, on my mac (squid installed with brew) this was

```bash
tail -f /opt/homebrew/var/logs/access.log
```

On vanilla Linux this is likely to be
```bash
tail -f /var/logs/access.log
```

Then in your browser just visit
http://localhost:9080/ratracejoe

And it should pull up the 'website', but go via the proxy.

To use curl, try this
```bash
curl --proxy localhost:3128 http://localhost:8080
```
And again, it should pull back the server running in docker, via the proxy you have running in your VM.

To see HTTPS in action, try

http://localhost:9080/external

It should try and pull the BBC homepage via HTTPS, but via the proxy...the logs seem to come through a little sporadically, but I think it worked...
