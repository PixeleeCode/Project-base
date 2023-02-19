# Executables (local)
DOCKER      = docker
DOCKER_COMP = docker compose
YARN = yarn

# Docker containers
PHP_CONT = $(DOCKER_COMP) exec php
REDIS_CONT = $(DOCKER_COMP) exec redis

# Executables
PHP      = $(PHP_CONT) php
COMPOSER = $(PHP_CONT) composer
SYMFONY  = $(PHP_CONT) bin/console
PHPQA    = $(DOCKER) run --init -it --rm -v "$(shell pwd):/project" -v "$(shell pwd)/tmp-phpqa:/tmp" -w /project jakzal/phpqa:php8.1-alpine

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start down logs sh composer vendor sf cc

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
build: ## Builds the Docker images
	@$(DOCKER_COMP) build --pull --no-cache

up: ## Start the docker hub in detached mode (no logs)
	@$(DOCKER_COMP) up --detach

start: build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

restart: down up ## Restart the docker hub

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to the PHP FPM container
	@$(PHP_CONT) sh

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

reset-db: ## Reset the dev database
	@$(SYMFONY) doctrine:database:drop --force
	@$(SYMFONY) doctrine:database:create
	@$(SYMFONY) doctrine:schema:create
	@$(SYMFONY) doctrine:migration:sync
	@$(SYMFONY) doctrine:migration:version --add --all --no-interaction

fixtures: ## Insert all fixtures
	@$(SYMFONY) doctrine:fixtures:load --no-interaction

## —— Code Quality 💚 ——————————————————————————————————————————————————————————
phpqa: ## Run command with phpqa image. Pass a command with "c=", eg: make phpqa c="phpstan analyze api/src"
	@$(eval c ?=)
	@$(PHPQA) $(c)

cs-fix: ## Run cs-fixer
	@$(COMPOSER) csfix

lint: ## Rune ESLint
	@$(YARN) lint

phpstan: ## Run phpstan
	@$(eval f ?=./src ./tests)
	@$(PHPQA) phpstan analyze -a ./vendor/autoload.php --level=6 -- $(f)

security-checker: ## Run php-security-checker
	@$(PHPQA) local-php-security-checker --no-dev --path=./composer.lock

quality: cs-fix phpstan lint security-checker ## Run all tests and code quality tools
