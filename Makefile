# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php

# Executables
PHP_LOCAL = php bin/console
PHP = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY = $(PHP) bin/console
REDIS_CONT = $(DOCKER_COMP) exec redis
PHPQA = $(DOCKER) run --init -it --rm -v "$(shell pwd):/project" -v "$(shell pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa:php8.3-alpine

# Misc
.DEFAULT_GOAL = help
.PHONY        : help build up down start restart logs sh bash test install-cs-fixer composer vendor sf cc import-map assets-compile assets-watch assets-minify reset-db fixtures reset-db-dev reset-db-prod phpqa cs-fix phpstan quality

# Variable to include additional docker-compose files
COMPOSE_FILES =

# Include the dev compose file if DEV is set
ifeq ($(PROD), 1)
    COMPOSE_FILES += compose.prod.yaml
endif

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) \
		build --pull --no-cache

up: ## Start the Docker containers in detached mode
	@$(DOCKER_COMP) \
		$(foreach file, $(COMPOSE_FILES), -f $(file)) \
		up --detach --force-recreate --remove-orphans

## Stop the Docker containers
down:
	$(DOCKER_COMP) \
		$(foreach file, $(COMPOSE_FILES), -f $(file)) \
		down --remove-orphans

## Build and start the containers
start: build up import-map
	@$(MAKE) assets-compile

## Restart the Docker containers
restart: down up ## Restart the docker hub

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the FrankenPHP container
	@$(PHP_CONT) sh

bash: ## Connect to the FrankenPHP container via bash so up and down arrows go to previous commands
	@$(PHP_CONT) bash

test: ## Start tests with phpunit, pass the parameter "c=" to add options to phpunit, example: make test c="--group e2e --stop-on-failure"
	@$(eval c ?=)
	@$(DOCKER_COMP) exec -e APP_ENV=test php bin/phpunit $(c)

install-cs-fixer: ## Install php-cs-fixer
	@$(COMPOSER) install --working-dir=tools/php-cs-fixer

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
composer: ## Run composer, pass the parameter "c=" to run a given command, example: make composer c='req symfony/orm-pack'
	@$(eval c ?=)
	@$(COMPOSER) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction
vendor: composer

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
sf: ## List all Symfony commands or pass the parameter "c=" to run a given command, example: make sf c=about
	@$(eval c ?=)
	@$(SYMFONY) $(c)

cc: ## Clear the cache Symfony & Redis
	@$(SYMFONY) c:c
	@$(REDIS_CONT) redis-cli FLUSHALL

import-map: ## Import map
	@$(SYMFONY) importmap:install

assets-compile: ## Compile assets
	@$(SYMFONY) tailwind:build
	@$(SYMFONY) asset-map:compile

assets-watch: ## Watch assets for changes
	@$(PHP_LOCAL) tailwind:build --watch

assets-minify: ## Minify assets
	@$(PHP_LOCAL) tailwind:build --minify
	@$(PHP_LOCAL) asset-map:compile

reset-db: ## Reset the dev database
	@echo "Resetting the database... Are you sure? [y/N]" && read ans && [ $${ans:-N} = y ]
	@$(SYMFONY) doctrine:database:drop --force
	@$(SYMFONY) doctrine:database:create
	@$(SYMFONY) doctrine:schema:create
	@$(SYMFONY) doctrine:migration:sync
	@$(SYMFONY) doctrine:migration:version --add --all --no-interaction

fixtures: ## Insert fixtures, use FIXTURE_GROUP env variable to load a specific group, example: make fixtures FIXTURE_GROUP=group1
	@$(SYMFONY) doctrine:fixtures:load --group=$${FIXTURE_GROUP:-dev} --no-interaction

reset-db-dev: reset-db fixtures

reset-db-prod: reset-db
	@$(MAKE) fixtures FIXTURE_GROUP=prod

## —— Code Quality 💚 ——————————————————————————————————————————————————————————
phpqa: ## Run command with phpqa image. Pass a command with "c=", eg: make phpqa c="phpstan analyze api/src"
	@$(eval c ?=)
	@$(PHPQA) $(c)

cs-fix: ## Run cs-fixer
	@$(COMPOSER) csfix

phpstan: ## Run phpstan
	@$(COMPOSER) phpstan

quality: cs-fix phpstan ## Run all tests and code quality tools
