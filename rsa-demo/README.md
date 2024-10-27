# Messaging Demo

This folder contains files for demonstrating messaging between two parties
* Alice
* Bob
* Charlie

It also contains a simple web server setup for alice.com with a certificate signed
by the trusted CA 'the-boss'.

# Commands Used

To regenerate all the files, run the included script
```bash
./create-rsa-demo-files.sh
```

At a few points this script will ask for a password.
The first two are you setting the password for 'the-boss', and the subsequent ones are using that password to sign certificates for alice, bob and charlie.

To run the web servers, use the following commands.

```bash
docker compose -f alice/docker-compose.yaml up -d
docker compose -f bob/docker-compose.yaml up -d
```

You can then make requests of the server with curl
```bash
curl \
    --cacert temp/trustable-tom/trustable-tom.crt \
    https://alice.127.0.0.1.nip.io:10443/index.html
curl \
    --cacert temp/trustable-tom/trustable-tom.crt \
    --cert temp/charlie/charlie.crt \
    --key temp/charlie/charlie.key \
    https://bob.127.0.0.1.nip.io:11443/index.html
```
