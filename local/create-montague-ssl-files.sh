rm montague/*
rm montague/romeo/*
rm montague/tybalt/*

# Creating Montague CA
openssl req \
-x509 \
-newkey ec -pkeyopt ec_paramgen_curve:prime256v1 \
-new -nodes \
-sha256 -days 1825 \
-out montague/montague.crt \
-keyout montague/montague.key \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=montague"

# Creating Romeo
openssl genrsa -out montague/romeo/romeo.key 4096
openssl rsa -in montague/romeo/romeo.key -pubout -out montague/romeo/romeo.pub.key

# Create Romeo CSR
openssl req \
-new -key montague/romeo/romeo.key \
-out montague/romeo/romeo.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=romeo.com"

# Signing Romeo CSR
cat > montague/romeo/romeo.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = romeo.com
IP.1 = 127.0.0.1
EOF

openssl x509 \
-req -in montague/romeo/romeo.csr \
-CA montague/montague.crt \
-CAkey montague/montague.key \
-CAcreateserial \
-out montague/romeo/romeo.crt \
-days 365 \
-sha256 \
-extfile montague/romeo/romeo.ext

# Creating Tybalt
openssl genrsa -out montague/tybalt/tybalt.key 4096
openssl rsa -in montague/tybalt/tybalt.key -pubout -out montague/tybalt/tybalt.pub.key

# This extra file is required by Firefox as the client cert
openssl pkcs12 -export \
-in montague/tybalt/tybalt.crt \
-inkey montague/tybalt/tybalt.key \
-name tybalt \
-out montague/tybalt/tybalt.p12 \
-passout pass:changeit

# Create Tybalt CSR
openssl req \
-new -key montague/tybalt/tybalt.key \
-out montague/tybalt/tybalt.csr \
-subj "/C=GB/ST=London/L=London/O=ratracejoe/OU=BX/CN=tybalt.com"

# Signing Tybalt CSR
cat > montague/tybalt/tybalt.ext << EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = localhost
DNS.2 = tybalt.com
IP.1 = 127.0.0.1
EOF

openssl x509 \
-req -in montague/tybalt/tybalt.csr \
-CA montague/montague.crt \
-CAkey montague/montague.key \
-CAcreateserial \
-out montague/tybalt/tybalt.crt \
-days 365 \
-sha256 \
-extfile montague/tybalt/tybalt.ext
