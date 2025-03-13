rm montague/*.*
rm montague/romeo/*
rm montague/tybalt/*

echo "Creating Montague CA"
openssl req \
-x509 \
-newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
-new -nodes \
-sha256 -days 1825 \
-out montague/montague.crt \
-keyout montague/montague.key \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=montague"

echo "Generating Java Trust Store for CA Montague"
keytool -importcert \
  -noprompt \
  -keystore montague/montague.truststore.jks \
  -storepass changeit \
  -file montague/montague.crt

echo "Creating Romeo"
openssl genrsa -out montague/romeo/romeo.key 4096
openssl rsa -in montague/romeo/romeo.key -pubout -out montague/romeo/romeo.pub.key

echo "Create Romeo CSR"
openssl req \
-new -key montague/romeo/romeo.key \
-out montague/romeo/romeo.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=romeo.${LOCAL_STACK}.nip.io"

echo "Generating Romeo EXT file"
cat > montague/romeo/romeo.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = romeo.${LOCAL_STACK}.nip.io
IP.1 = ${LOCAL_STACK}
EOF

echo "Signing Romeo Certificate"
openssl x509 \
-req -in montague/romeo/romeo.csr \
-CA montague/montague.crt \
-CAkey montague/montague.key \
-CAcreateserial \
-out montague/romeo/romeo.crt \
-days 365 \
-sha256 \
-extfile montague/romeo/romeo.ext

echo "Generating Romeo p12"
openssl pkcs12 -export \
-in montague/romeo/romeo.crt \
-inkey montague/romeo/romeo.key \
-name romeo \
-out montague/romeo/romeo.p12 \
-passout pass:changeit

echo "Generating Java Key Store for Romeo"
keytool -importkeystore \
  -noprompt \
  -deststorepass changeit \
  -destkeypass changeit \
  -destkeystore montague/romeo/romeo.keystore.jks \
  -srckeystore montague/romeo/romeo.p12 \
  -srcstoretype PKCS12 \
  -srcstorepass changeit

echo "Importing Certificate into Java Key Store for Juliet"
keytool -importcert \
  -noprompt \
  -keystore montague/romeo/romeo.keystore.jks \
  -storepass changeit \
  -file montague/romeo/romeo.crt


echo "Creating Tybalt"
openssl genrsa -out montague/tybalt/tybalt.key 4096
openssl rsa -in montague/tybalt/tybalt.key -pubout -out montague/tybalt/tybalt.pub.key

echo "Create Tybalt CSR"
openssl req \
-new -key montague/tybalt/tybalt.key \
-out montague/tybalt/tybalt.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=tybalt.${LOCAL_STACK}.nip.io"

echo "Generating Tybalt Ext File"
cat > montague/tybalt/tybalt.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = tybalt.${LOCAL_STACK}.nip.io
IP.1 = ${LOCAL_STACK}
EOF

echo "Signing Tybalt Certificate"
openssl x509 \
-req -in montague/tybalt/tybalt.csr \
-CA montague/montague.crt \
-CAkey montague/montague.key \
-CAcreateserial \
-out montague/tybalt/tybalt.crt \
-days 365 \
-sha256 \
-extfile montague/tybalt/tybalt.ext

echo "Generating Tybalt p12"
openssl pkcs12 -export \
-in montague/tybalt/tybalt.crt \
-inkey montague/tybalt/tybalt.key \
-name tybalt \
-out montague/tybalt/tybalt.p12 \
-passout pass:changeit

echo "Generating Java Key Store for Tybalt"
keytool -importkeystore \
  -noprompt \
  -deststorepass changeit \
  -destkeypass changeit \
  -destkeystore montague/tybalt/tybalt.keystore.jks \
  -srckeystore montague/tybalt/tybalt.p12 \
  -srcstoretype PKCS12 \
  -srcstorepass changeit

echo "Importing Certificate into Java Key Store for Tybalt"
keytool -importcert \
  -noprompt \
  -keystore montague/tybalt/tybalt.keystore.jks \
  -storepass changeit \
  -file montague/tybalt/tybalt.crt


echo "Copying Everything over to test"
rm -rf ../src/test/resources/tls/montague
cp -R montague ../src/test/resources/tls
