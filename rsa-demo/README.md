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

As a one off, create the local resolutions for alice.com and bob.com using

```bash
sudo ./create-local-resolutions.sh
```

To run the web servers, use the following commands.

```bash
docker compose -f alice.com/docker-compose.yaml up -d
docker compose -f bob.com/docker-compose.yaml up -d
```
