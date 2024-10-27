TEMP_DIR="./temp"

rm -rf $TEMP_DIR/*
mkdir $TEMP_DIR/alice
mkdir $TEMP_DIR/bob
mkdir $TEMP_DIR/charlie
mkdir $TEMP_DIR/trustable-tom
mkdir $TEMP_DIR/message-demo

echo "alice - Generating Key Pair"
openssl genrsa -out $TEMP_DIR/alice/alice.key 4096
openssl rsa -in $TEMP_DIR/alice/alice.key -pubout -out $TEMP_DIR/alice/alice.pub.key

echo "bob - Generating Key Pair"
openssl genrsa -out $TEMP_DIR/bob/bob.key 4096
openssl rsa -in $TEMP_DIR/bob/bob.key -pubout -out $TEMP_DIR/bob/bob.pub.key

echo "alice - Creating Encrypted Message"
echo "Hello from alice 8981" > $TEMP_DIR/message-demo/plain.txt

echo "alice - Encrypting Message"
openssl pkeyutl -encrypt \
	-inkey $TEMP_DIR/bob/bob.pub.key \
	-pubin -in $TEMP_DIR/message-demo/plain.txt \
	-out $TEMP_DIR/message-demo/cipher.enc

echo "alice - Signing Message"
openssl dgst -sha256 \
	-sign $TEMP_DIR/alice/alice.key \
	-out $TEMP_DIR/message-demo/cipher.enc.alice \
	$TEMP_DIR/message-demo/cipher.enc

echo "bob - Verifying Message"
openssl dgst -sha256 \
	-verify $TEMP_DIR/alice/alice.pub.key \
	-signature $TEMP_DIR/message-demo/cipher.enc.alice \
	$TEMP_DIR/message-demo/cipher.enc

echo "bob - Decrypting Message"
openssl pkeyutl -decrypt \
	-inkey $TEMP_DIR/bob/bob.key \
	-in $TEMP_DIR/message-demo/cipher.enc \
	-out $TEMP_DIR/message-demo/received.txt

echo "Printing Message"
cat $TEMP_DIR/message-demo/received.txt

echo "Trustable Tom - Creating a Certificate Authority"
echo "Will ask for a Password for Trustable Tom..."
openssl req \
	-x509 \
	-newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
	-new -sha256 -days 1825 \
	-out $TEMP_DIR/trustable-tom/trustable-tom.crt \
	-keyout $TEMP_DIR/trustable-tom/trustable-tom.key \
	-subj "/C=GB/ST=London/L=London/O=ECORP/OU=Eng/CN=trustable-tom.127.0.0.1.nip.io"

echo "alice - Creating a Certificate Signing Request (CSR)"
openssl req \
	-new -key $TEMP_DIR/alice/alice.key \
	-out $TEMP_DIR/alice/alice.csr \
	-subj "/C=GB/ST=London/L=London/O=ECORP/OU=Eng/CN=alice.127.0.0.1.nip.io"

echo "Trustable Tom - Constructing a Config for alice Cert"
cat > $TEMP_DIR/alice/alice.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = alice.127.0.0.1.nip.io
IP.1 = 127.0.0.1
EOF

echo "Trustable Tom - Signing the CSR for alice"
echo "Will ask for Trustable Tom Password..."
openssl x509 \
	-req -in $TEMP_DIR/alice/alice.csr \
	-CA $TEMP_DIR/trustable-tom/trustable-tom.crt \
	-CAkey $TEMP_DIR/trustable-tom/trustable-tom.key \
	-CAcreateserial \
	-out $TEMP_DIR/alice/alice.crt \
	-days 365 -sha256 \
	-extfile $TEMP_DIR/alice/alice.ext
	
echo "bob - Creating a Certificate Signing Request (CSR)"
openssl req \
	-new -key $TEMP_DIR/bob/bob.key \
	-out $TEMP_DIR/bob/bob.csr \
	-subj "/C=GB/ST=London/L=London/O=ECORP/OU=Eng/CN=bob.127.0.0.1.nip.io"

echo "Trustable Tom - Constructing a Config for bob Cert"
cat > $TEMP_DIR/bob/bob.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = bob.127.0.0.1.nip.io
IP.1 = 127.0.0.1
EOF

echo "Trustable Tom - Signing the CSR for bob"
echo "Will ask for Trustable Tom Password..."
openssl x509 \
	-req -in $TEMP_DIR/bob/bob.csr \
	-CA $TEMP_DIR/trustable-tom/trustable-tom.crt \
	-CAkey $TEMP_DIR/trustable-tom/trustable-tom.key \
	-CAcreateserial \
	-out $TEMP_DIR/bob/bob.crt \
	-days 365 -sha256 \
	-extfile $TEMP_DIR/bob/bob.ext

echo "Generating Trusted Visitor for bob.127.0.0.1.nip.io"
echo "charlie - Generating Key Pair"
openssl genrsa -out $TEMP_DIR/charlie/charlie.key 4096
openssl rsa -in $TEMP_DIR/charlie/charlie.key -pubout -out $TEMP_DIR/charlie/charlie.pub.key	

echo "charlie - Creating a Certificate Signing Request (CSR)"
openssl req \
	-new -key $TEMP_DIR/charlie/charlie.key \
	-out $TEMP_DIR/charlie/charlie.csr \
	-subj "/C=GB/ST=London/L=London/O=ECORP/OU=Eng/CN=charlie.127.0.0.1.nip.io"

echo "Trustable Tom - Constructing a Config for charlie Cert"
cat > $TEMP_DIR/charlie/charlie.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = charlie.127.0.0.1.nip.io
IP.1 = 127.0.0.1
EOF

echo "Trustable Tom - Signing the CSR for charlie"
echo "Will ask for Trustable Tom Password..."
openssl x509 \
	-req -in $TEMP_DIR/charlie/charlie.csr \
	-CA $TEMP_DIR/trustable-tom/trustable-tom.crt \
	-CAkey $TEMP_DIR/trustable-tom/trustable-tom.key \
	-CAcreateserial \
	-out $TEMP_DIR/charlie/charlie.crt \
	-days 365 -sha256 \
	-extfile $TEMP_DIR/charlie/charlie.ext

echo "Exporting Charlie Cert and Key to PKCS12"
# Legacy flag required on the mac
openssl pkcs12 -export --legacy \
	-in $TEMP_DIR/charlie/charlie.crt \
	-inkey $TEMP_DIR/charlie/charlie.key \
	-name charlie \
	-out $TEMP_DIR/charlie/charlie.p12 \
	-passout pass:changeit
