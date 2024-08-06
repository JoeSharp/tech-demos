# Messaging Demo

This folder contains files for demonstrating messaging between two parties
* Alice
* Bob

It also contains a simple web server setup for alice.com with a certificate signed
by the trusted CA 'the-boss'.

# Commands Used

## Key Creation
openssl genrsa -out alice/alice.key 4096
openssl rsa -in alice/alice.key -pubout -out alice/alice.pub.key

openssl genrsa -out bob/bob.key 4096
openssl rsa -in bob/bob.key -pubout -out bob/bob.pub.key

## Message Encryption
echo "Hello from Alice" > message-demo/plain.txt
openssl pkeyutl -encrypt \
-inkey bob/bob.pub.key \
-pubin in message-demo/plain.txt \
-out message-demo/cipher.enc

## Signing Encrypted Message
openssl dgst -sha256 \
-sign alice/alice.key \
-out message-demo/cipher.enc.alice \
message-demo/cipher.enc

## Verify Signature
openssl dgst -sha256 \
-verify alice/alice.pub.key \
-signature message-demo/cipher.enc.alice \
message-demo/cipher.enc

## Decrypt
openssl pkeyutl -decrypt \
-inkey bob/bob.key \
-in message-demo/cipher.enc \
-out message-demo/received.txt

cat received.txt

## Create a Certificate Authority (CA)
openssl req \
-x509 \
-newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
-new \
-sha256 -days 1825 \
-out the-boss/the-boss.crt \
-keyout the-boss/the-boss.key \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=the-boss"

## Create Certificate Signing Request
openssl req \
-new -key alice/alice.key \
-out alice/alice.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=alice.com"

## Signing the CSR
cat alice/alice.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = alice.com
IP.1 = 127.0.0.1
EOF

openssl x509 \
-req -in alice/alice.csr \
-CA the-boss/the-boss.crt \
-CAkey the-boss/the-boss.key \
-CAcreateserial \
-out alice/alice.crt \
-days 365 \
-sha256 \
-extfile alice/alice.ext

