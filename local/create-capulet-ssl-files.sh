rm capulet/*
rm capulet/juliet/*
rm capulet/the-nurse/*

# Creating Capulet CA
openssl req \
-x509 \
-newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
-new -nodes \
-sha256 -days 1825 \
-out capulet/capulet.crt \
-keyout capulet/capulet.key \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=capulet"

# Creating Juliet
openssl genrsa -out capulet/juliet/juliet.key 4096
openssl rsa -in capulet/juliet/juliet.key -pubout -out capulet/juliet/juliet.pub.key

# Create Juliet CSR
openssl req \
-new -key capulet/juliet/juliet.key \
-out capulet/juliet/juliet.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=juliet.com"

# Signing Juliet CSR
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

openssl x509 \
-req -in capulet/juliet/juliet.csr \
-CA capulet/capulet.crt \
-CAkey capulet/capulet.key \
-CAcreateserial \
-out capulet/juliet/juliet.crt \
-days 365 \
-sha256 \
-extfile capulet/juliet/juliet.ext

# Creating Capulet Nurse
openssl genrsa -out capulet/the-nurse/the-nurse.key 4096
openssl rsa -in capulet/the-nurse/the-nurse.key -pubout -out capulet/the-nurse/the-nurse.pub.key

# Create Capulet Nurse CSR
openssl req \
-new -key capulet/the-nurse/the-nurse.key \
-out capulet/the-nurse/the-nurse.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=the-nurse.com"

# This extra file is required by Firefox as the client cert
openssl pkcs12 -export \
-in capulet/the-nurse/the-nurse.crt \
-inkey capulet/the-nurse/the-nurse.key \
-name the-nurse \
-out capulet/the-nurse/the-nurse.p12 \
-passout pass:changeit

# Signing Capulet Nurse CSR
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

openssl x509 \
-req -in capulet/the-nurse/the-nurse.csr \
-CA capulet/capulet.crt \
-CAkey capulet/capulet.key \
-CAcreateserial \
-out capulet/the-nurse/the-nurse.crt \
-days 365 \
-sha256 \
-extfile capulet/the-nurse/the-nurse.ext
