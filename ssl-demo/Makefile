export LOCAL_STACK_CIDR=172.18.5.0/24
export LOCAL_STACK=172.18.5.1

docker-run-quick:
	docker compose -f local/docker-compose.yaml --profile include-app up -d --wait

docker-run: local-stack docker-build docker-run-quick

docker-stop:
	docker compose -f local/docker-compose.yaml --profile include-app down

nginx-run: local-stack
	docker compose -f local/docker-compose.yaml up -d --wait

bootrun: run-nginx
	./gradlew clean bootrun

docker-build: app-build
	docker build --platform=linux/amd64 -t ssl-demo:latest .

app-build:
	./gradlew clean build

refresh-certs:
	cd local && \
	./create-capulet-ssl-files.sh && \
	./create-montague-ssl-files.sh && \
	cd ..

test-curl: local-stack
	cd local && \
 	./test-curl.sh \
	cd ..

test-junit:
	./gradlew test
