run-docker: build-docker-image
	docker compose -f local/docker-compose.yaml --profile include-app up -d --wait

stop-docker:
	docker compose -f local/docker-compose.yaml --profile include-app down

run-nginx:
	docker compose -f local/docker-compose.yaml up -d --wait

run-bootrun: run-nginx
	./gradlew clean bootrun

build-docker-image: build-app
	docker build -t ssl-demo:latest .

build-app:
	./gradlew clean build

refresh-certs:
	cd local && \
	./create-capulet-ssl-files.sh && \
	./create-montague-ssl-files.sh && \
	cd ..

run-test:
	cd local && \
 	./run-test.sh \
	cd ..

unit-tests:
	./gradlew test
