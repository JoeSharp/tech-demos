# Local VM - Allocated IP address

When a docker container tries to reach 'localhost', it will only reach within the container. If the docker container needs to reach outside, it needs a non ambiguous IP address it can use.

We can create such an IP on the host machine, and have an environment variable in place we can pass to containers so they have a means of addressing the host VM.

On the host machine, let's create a special IP now,
all of these commands will need to be run in one terminal so that the environment variable is there.

```bash
ip a 
export DEMO_VM_IP=10.0.0.45

# pick an appropriate network interface, I'm going with 'lo'
sudo ip addr add $DEMO_VM_IP/32 dev lo

# Try and ping it, check it resolves to the local VM
ping $DEMO_VM_IP
```

Now we can run the docker compose file (same terminal)

```bash
docker compose up -d
```

It should now be possible to reach
* lister on port 8080
* kirk on port 9080

Note that as far as nginx is concerned, it's coming up on port 80, but that's only within the container.

The port mappings then expose specific ports to the host via the bridged network.

```bash
# on host machine
wget -O - $DEMO_VM_IP:9080
```

You could now create resolutions for lister and kirk in your /etc/hosts file, allowing the local VM to use the same host resolutions as the containers.

## Reaching Across Networks

Now that we have an IP that resolves to our host VM, it should be possible to use that IP within our containers to reach from one network to another.

```bash
docker exec rimmer wget -O - $DEMO_VM_IP:8080
docker exec rimmer wget -O - $DEMO_VM_IP:9080
```

Note that rimmer itself is not aware of the env variable DEMO_VM_IP, that's being subsituted in before the command is sent to the container.

But this shows that the rimmer container is able to reach both the red-dwarf and star-trek web servers, going via the IP that is bound to the local VM.

## Clean up
We should delete this IP address that was created just for this test. Although it shouldn't persist across a system restart.

```bash
sudo ip addr del $DEMO_VM_IP/32 dev lo
```
