.PHONY: image push run debug clean

export DOCKER_REPO ?= jtilander
P4_VERSION ?= 16.2
export TAG ?= test

DATAVOLUMES ?= `pwd`/tmp

DC=docker-compose
DC_FLAGS="-p perforce"

ifeq (run,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif

VOLUMES=-v $(DATAVOLUMES)/metadata:/metadata -v $(DATAVOLUMES)/library:/library -v $(DATAVOLUMES)/journals:/journals -v $(DATAVOLUMES)/backup:/backup

image:
	docker build -t $(DOCKER_REPO)/p4d:$(TAG) --build-arg P4_VERSION=$(P4_VERSION) .
	docker images $(DOCKER_REPO)/p4d:$(TAG)

push:
	docker push $(DOCKER_REPO)/p4d:$(TAG)

run:
	docker run --rm $(VOLUMES) -p 1666:1666 $(DOCKER_REPO)/p4d:$(TAG) $(RUN_ARGS)

debug:
	docker run --rm -it $(VOLUMES) $(DOCKER_REPO)/p4d:$(TAG) bash

clean:
	rm -rf $DATAVOLUMES && mkdir $DATAVOLUMES

checkpoint:
	docker run --rm $(VOLUMES) $(DOCKER_REPO)/p4d:$(TAG) checkpoint

backup:
	docker run --rm $(VOLUMES) $(DOCKER_REPO)/p4d:$(TAG) backup

restore:
	docker run --rm $(VOLUMES) $(DOCKER_REPO)/p4d:$(TAG) restore checkpoint.gz

nuke: clean
	docker rmi `docker images -q -a $(DOCKER_REPO)/p4d:$(TAG)`

up:
	$(DC) $(DC_FLAGS) up -d && $(DC) $(DC_FLAGS) logs -f

down:
	$(DC) $(DC_FLAGS) down

kill:
	$(DC) $(DC_FLAGS) down -v
