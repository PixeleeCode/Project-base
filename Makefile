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
.PHONY        : help build up start down logs sh composer vendor sf cc test

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up-dev: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

up-prod:
	@$(DOCKER_COMP) -f docker-compose.yml -f docker-compose.prod.yml up -d

start-dev: build up-dev assets-compile ## Build and start the containers
start-prod: build up-prod assets-minify ## Build and start the containers in mode prod

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

restart-dev: down up-dev ## Restart the docker hub
restart-prod: down up-prod ## Restart the docker hub

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the FrankenPHP container
	@$(PHP_CONT) sh

bash: ## Connect to the FrankenPHP container via bash so up and down arrows go to previous commands
	@$(PHP_CONT) bash

test: ## Start tests with phpunit, pass the parameter "c=" to add options to phpunit, example: make test c="--group e2e --stop-on-failure"
	@$(eval c ?=)
	@$(DOCKER_COMP) exec -e APP_ENV=test php bin/phpunit $(c)

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

assets-compile: ## Compile assets
	@$(PHP_LOCAL) tailwind:build
	@$(PHP_LOCAL) asset-map:compile

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
