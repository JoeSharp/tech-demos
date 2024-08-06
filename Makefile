run-docker: build-docker-image
	docker compose -f local/docker-compose.yaml --profile include-app up -d --wait

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
	./local/create-capulet-ssl-files.sh \
	./local/create-montague-ssl-files.sh \
	cd ..

run-test:
	cd local && \
 	./run-test.sh \
	cd ..
