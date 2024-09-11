# Kubernetes

These experiments require us to install minikube, and enable the inress addon.

Doing this is all readily available on the Minikube website, I won't duplicate it here.

The hello-minikube.yaml is ripped straight from their ingress tutorial.

## Minikube Utilities & Addons
Once applied, you will need to run the minikube tunnel to expose the ingresses to your local VM.
```bash
minikube tunnel
```

I also recommend running the Dashboard
```bash
minikube dashboard
```

## Dwarf Vs Trek

There are two other K8s config files

* red-dwarf
* star-trek

These can be applied with

```bash
kubectl apply -f red-dwarf.yaml
kubectl apply -f star-trek.yaml
```

and cleaned up (later) with
```bash
kubectl delete -f red-dwarf.yaml
kubectl delete -f star-trek.yaml
```

Once running, we can exec onto the rimmer container and try and reach lister, but this time we will use localhost, to show that the two containers are on the same virtual host by virtue of being containers in a pod.

```bash
kubectl exec -it deployment/red-dwarf -c rimmer -- /bin/sh

wget -O - localhost
```

But the red-dwarf container can reach the Star Trek container using
```
wget -O - star-trek:9080
```

This is using the service, rather than the ingress.
The ingress is how we can access the nginx instances from outside of Minikube (via the tunnel)
