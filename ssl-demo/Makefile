export LOCAL_STACK=172.18.5.0
#
# Figure out which operating system we are on
UNAME := $(shell uname)

local-stack:
	echo "Registering IP address for Local Development"
ifeq ($(UNAME), Linux)
	sudo ip addr replace ${LOCAL_STACK} dev lo
endif
ifeq ($(UNAME), Darwin)
	sudo ifconfig en0 alias ${LOCAL_STACK}/32 up
endif

run-docker: local-stack build-docker-image
	docker compose -f local/docker-compose.yaml --profile include-app up -d --wait

stop-docker:
	docker compose -f local/docker-compose.yaml --profile include-app down

run-nginx: local-stack
	docker compose -f local/docker-compose.yaml up -d --wait

run-bootrun: run-nginx
	./gradlew clean bootrun

build-docker-image: build-app
	docker build --platform=linux/amd64 -t ssl-demo:latest .

build-app:
	./gradlew clean build

refresh-certs:
	cd local && \
	./create-capulet-ssl-files.sh && \
	./create-montague-ssl-files.sh && \
	cd ..

run-test: local-stack
	cd local && \
 	./run-test.sh \
	cd ..

unit-tests:
	./gradlew test
