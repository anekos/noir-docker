APP_TEMP := $(shell mktemp -d)
API_REPOS = ../api
WEB_REPOS = ../web

WHL_FILENAME=noir_api-0.1.0-py3-none-any.whl

.PHONY: build shell run deploy

build:
	( cd $(API_REPOS) && rye build )
	cp $(API_REPOS)/dist/$(WHL_FILENAME) $(WHL_FILENAME)
	( cd $(WEB_REPOS) &&  elm make src/Main.elm --output build/elm.js )
	docker build -t noir .

shell:
	docker run \
		--name noir-app \
		--interactive \
		--rm \
		--tty \
		-p 8000:8000 \
		-e NOIR_API_DOWNLOAD_TO=$(NOIR_API_DOWNLOAD_TO) \
		-e NOIR_API_ALIASES_PATH=$(NOIR_API_ALIASES_PATH) \
		-e NOIR_API_DB_URL=$(NOIR_API_DB_URL) \
		-e NOIR_HTML_ROOT=/app/web \
		-v $(NOIR_HTML_ROOT):/app/web \
		-v $(IMAGE_DIR):$(IMAGE_DIR) \
		noir \
		/bin/bash

run:
	docker run \
		--name noir-app \
		--interactive \
		--rm \
		-p 8000:8000 \
		-e NOIR_API_DOWNLOAD_TO=$(NOIR_API_DOWNLOAD_TO) \
		-e NOIR_API_ALIASES_PATH=$(NOIR_API_ALIASES_PATH) \
		-e NOIR_API_DB_URL=$(NOIR_API_DB_URL) \
		-e NOIR_HTML_ROOT=/app/web \
		-v $(NOIR_HTML_ROOT):/app/web \
		-v $(IMAGE_DIR):$(IMAGE_DIR) \
		--tty \
		noir


deploy:
	docker tag noir irmagi.local.anekos.com:5000/noir
	docker push irmagi.local.anekos.com:5000/noir