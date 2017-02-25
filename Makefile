.PHONY: image push run debug clean

export DOCKER_REPO ?= jtilander
P4_VERSION ?= 16.2
export TAG ?= test

DC=docker-compose
DC_FLAGS="-p perforce"

image:
	docker build -t $(DOCKER_REPO)/p4d:$(TAG) --build-arg P4_VERSION=$(P4_VERSION) .
	docker images $(DOCKER_REPO)/p4d:$(TAG)

push:
	docker push $(DOCKER_REPO)/p4d:$(TAG)

run:
	docker run --rm -p 1666 $(DOCKER_REPO)/p4d:$(TAG)

debug:
	docker run --rm -it $(DOCKER_REPO)/p4d:$(TAG) bash

clean:
	docker rmi `docker images -q -a $(DOCKER_REPO)/p4d:$(TAG)`

up:
	$(DC) $(DC_FLAGS) up -d && $(DC) $(DC_FLAGS) logs -f

down:
	$(DC) $(DC_FLAGS) down

kill:
	$(DC) $(DC_FLAGS) down -v
