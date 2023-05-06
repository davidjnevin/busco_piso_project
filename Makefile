# Define constants
IMAGE_NAME := busco_piso_project
CONTAINER_NAME := busco_piso_container
DOCKER_RUN := docker run --rm -v $(PWD):/app $(IMAGE_NAME)
APP_HOME := /app/src /app/tests

.PHONY: build test shell check-code clean-code up down clean-volumes

# Build the Docker image
build:
	docker build -t $(IMAGE_NAME) .

# Run tests using pytest within the Docker container
test:
	docker exec $(CONTAINER_NAME) pytest

# Open an interactive shell within the Docker container
shell:
	docker run -it --rm $(IMAGE_NAME) bash

# Check code using flake8, isort, and black without making any changes
check-code:
	docker exec $(CONTAINER_NAME) flake8 --config /app/.flake8 $(APP_HOME)
	docker exec $(CONTAINER_NAME) isort --check-only --profile black $(APP_HOME)
	docker exec $(CONTAINER_NAME) black --check $(APP_HOME)

# Format code using isort and black
clean-code:
	docker exec $(CONTAINER_NAME) isort --profile black $(APP_HOME)
	docker exec $(CONTAINER_NAME) black $(APP_HOME)

# Run the container in detached mode with port mapping
up:
	docker run -d --name $(CONTAINER_NAME) -p 8000:8000 $(IMAGE_NAME)

# Stop and remove the container
down:
	docker stop $(CONTAINER_NAME)
	docker rm $(CONTAINER_NAME)

# Clean up dangling volumes
clean-volumes:
	docker volume prune -f
