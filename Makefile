
.PHONY: build-docker
build-docker:
	docker build -t noir-app .

.PHONY: build-api
build-api:
	(cd api ; cargo build)

.PHONY: build-web
build-web:
	(cd web ; yarn install && npm run build)

