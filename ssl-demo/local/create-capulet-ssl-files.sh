echo "Cleaning Files"
rm capulet/*.*
rm capulet/juliet/*
rm capulet/the-nurse/*

echo "Creating Capulet CA"
openssl req \
-x509 \
-newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
-new -nodes \
-sha256 -days 1825 \
-out capulet/capulet.crt \
-keyout capulet/capulet.key \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=capulet"

echo "Generating Java Trust Store for CA Capulet"
keytool -importcert \
  -noprompt \
  -keystore capulet/capulet.truststore.jks \
  -storepass changeit \
  -file capulet/capulet.crt

echo "Creating Juliet"
openssl genrsa -out capulet/juliet/juliet.key 4096
openssl rsa -in capulet/juliet/juliet.key -pubout -out capulet/juliet/juliet.pub.key

echo "Create Juliet CSR"
openssl req \
-new -key capulet/juliet/juliet.key \
-out capulet/juliet/juliet.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=juliet.com"

echo "Generating Juliet CSR"
cat > capulet/juliet/juliet.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = juliet.com
IP.1 = 127.0.0.1
EOF

echo "Signing Juliet Certificate"
openssl x509 \
-req -in capulet/juliet/juliet.csr \
-CA capulet/capulet.crt \
-CAkey capulet/capulet.key \
-CAcreateserial \
-out capulet/juliet/juliet.crt \
-days 365 \
-sha256 \
-extfile capulet/juliet/juliet.ext

echo "Generating Juliet p12"
openssl pkcs12 -export \
-in capulet/juliet/juliet.crt \
-inkey capulet/juliet/juliet.key \
-name juliet \
-out capulet/juliet/juliet.p12 \
-passout pass:changeit

echo "Generating Java Key Store for Juliet"
keytool -importkeystore \
  -noprompt \
  -deststorepass changeit \
  -destkeypass changeit \
  -destkeystore capulet/juliet/juliet.keystore.jks \
  -srckeystore capulet/juliet/juliet.p12 \
  -srcstoretype PKCS12 \
  -srcstorepass changeit

echo "Importing Certificate into Java Key Store for Juliet"
keytool -importcert \
  -noprompt \
  -keystore capulet/juliet/juliet.keystore.jks \
  -storepass changeit \
  -file capulet/juliet/juliet.crt

echo "Creating Capulet Nurse"
openssl genrsa -out capulet/the-nurse/the-nurse.key 4096
openssl rsa -in capulet/the-nurse/the-nurse.key -pubout -out capulet/the-nurse/the-nurse.pub.key

echo "Create Capulet Nurse CSR"
openssl req \
-new -key capulet/the-nurse/the-nurse.key \
-out capulet/the-nurse/the-nurse.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=the-nurse.com"

echo "Generating Capulet Nurse Ext File"
cat > capulet/the-nurse/the-nurse.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = the-nurse.com
IP.1 = 127.0.0.1
EOF

echo "Signing Capulet Nurse Certificate"
openssl x509 \
-req -in capulet/the-nurse/the-nurse.csr \
-CA capulet/capulet.crt \
-CAkey capulet/capulet.key \
-CAcreateserial \
-out capulet/the-nurse/the-nurse.crt \
-days 365 \
-sha256 \
-extfile capulet/the-nurse/the-nurse.ext

echo "Generating The Nurse p12"
openssl pkcs12 -export \
-in capulet/the-nurse/the-nurse.crt \
-inkey capulet/the-nurse/the-nurse.key \
-name the-nurse \
-out capulet/the-nurse/the-nurse.p12 \
-passout pass:changeit

echo "Generating Java Key Store for The Nurse"
keytool -importkeystore \
  -noprompt \
  -deststorepass changeit \
  -destkeypass changeit \
  -destkeystore capulet/the-nurse/the-nurse.keystore.jks \
  -srckeystore capulet/the-nurse/the-nurse.p12 \
  -srcstoretype PKCS12 \
  -srcstorepass changeit

echo "Importing Certificate into Java Key Store for Juliet"
keytool -importcert \
  -noprompt \
  -keystore capulet/the-nurse/the-nurse.keystore.jks \
  -storepass changeit \
  -file capulet/the-nurse/the-nurse.crt


echo "Copying Everything over to test"
rm -rf ../src/test/resources/tls/capulet
cp -R capulet ../src/test/resources/tls