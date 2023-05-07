# Include the .env file
include .env
export

# Define constants

.PHONY: build test shell check-code clean-code up down clean-volumes
SHELL=/bin/bash
DOCKER_COMPOSE=docker compose
DOCKER_ENVIRONMENT=docker-compose.yml
APP_HOME := /app/src /app/tests
PACKAGE_NAME=app
VENV_FOLDER=venv
LAUNCH_IN_VENV=source ${VENV_FOLDER}/bin/activate &&
PYTHON_VERSION=python3.11
WEB_DOCKER_SERVICE_NAME=busco_piso_web
WEB_DOCKER_CONTAINER_NAME=busco_piso_web_container
DB_DOCKER_SERVICE_NAME=busco_piso_db



# target: all - Default target. Does nothing.
all:
	@echo "Hello $(LOGNAME), nothing to do by default"
	@echo "Try 'make help'"

# target: help - Display callable targets.
help:
	@egrep "^# target:" [Mm]akefile

# target: setup - prepare environment
setup:
	rm -rf ${VENV_FOLDER}
	${PYTHON_VERSION} -m venv ${VENV_FOLDER}
	${LAUNCH_IN_VENV} pip install -r requirements.txt
	${LAUNCH_IN_VENV} pip install -r requirements-dev.txt

# target: build - Build the docker images
build:
	${DOCKER_COMPOSE} -f ${DOCKER_ENVIRONMENT} build

# Run the container in detached mode with port mapping
run:
	${DOCKER_COMPOSE} -f ${DOCKER_ENVIRONMENT} up -d

# taget: down - Stop the project
down:
	${DOCKER_COMPOSE} -f ${DOCKER_ENVIRONMENT} down -v

# target: clean-volumes - Stop the project and clean all volumes
clean-volumes:
	${DOCKER_COMPOSE} -f ${DOCKER_ENVIRONMENT} down -v

# target: logs - Show project logs
logs:
	${DOCKER_COMPOSE} -f ${DOCKER_ENVIRONMENT} logs -f

# target: enter postgres shell
.PHONY: postgres
postgres:
	${DOCKER_COMPOSE} exec ${DB_DOCKER_SERVICE_NAME} psql -U postgres

.PHONY: build-schema
build-schema:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} python app/db.py

# target: flake8 - check code
.PHONY: flake8
flake8:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} flake8 .

# target: black - check code
.PHONY: black-diff
black-diff:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} black . --diff

# target: black - check code
.PHONY: black-check
black-check:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} black . --check

# target: black - check code
.PHONY: black
black:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} black .

.PHONY: isort
isort:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} isort .

# target: test - test code
.PHONY: test
test:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} python -m pytest

# target: lint - Lint the code
.PHONY: lint
lint:
	${PRE_RUN_API_COMMAND} lint

# target: check code flake8, isort, and black --check-only
check-code:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} flake8 --config /app/.flake8 $(APP_HOME)
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} isort --check-only --profile black $(APP_HOME)
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} black --check $(APP_HOME)

# Format code using isort and black
clean-code:
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} isort --profile black $(APP_HOME)
	${DOCKER_COMPOSE} exec ${WEB_DOCKER_SERVICE_NAME} black $(APP_HOME)
