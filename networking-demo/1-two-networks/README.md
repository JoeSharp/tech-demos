# Networking and Containers

## Run a Linux container

This will run a small linux container, and keep it alive for interacting with.

```bash
docker run -d --name alpine-rimmer alpine tail -f /dev/null
```

## Running Multiple Networks
A docker compose file is provided which creates two networks, with an alpine and an nginx host on each
* red-dwarf
 * lister - nginx
 * rimmer - alpine
* star-trek
 * kirk - nginx
 * picard - alpine

```bash
docker compose up -d
```

If you want to get an interactive shell on any box, use commands like this

```bash
docker exec -it rimmer /bin/sh
```
* -it is for 'interactive terminal'
* /bin/sh is the shell command, different containers might have different shells, but this one is usually available.

In most of the commands below, I'm not going to run an interactive terminal, and just run commands on those boxes in one go.

### Reaching Hosts from Each other
It should then be possible to logon to either of the alpine boxes and try and reach the nginx on that network.

This command can be used to pull the nginx homepage from lister to rimmer

```bash
docker exec rimmer wget -O - lister
```

If you try and reach the picard nginx from rimmer, it should fail because it's on a different network.

## IP Addresses

To get the IP addresses of the linux boxes, you can run the `ip a` command directly like this.

```bash
docker exec rimmer ip a
```

This can't be done within the nginx boxes, but you can get a full description of the network from docker

```bash
docker network inspect red-dwarf
```

The IP addresses here should agree with those from the `ip a` command from the individual boxes.
