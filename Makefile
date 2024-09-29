SHELL = /bin/bash
.ONESHELL:
.DEFAULT_GOAL: help

help: ## Prints available commands
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[.a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

containers.up: ## Builds the containers
	@docker compose up -d

containers.down: ## Stops the containers
	@docker compose down -v

containers.stats: ## Show docker stats
	@docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}"

bundle: ## Installs library dependencies
	@docker compose run web bundle

db.setup: ## Creates the database, runs migrations and seeds the data
	@docker compose run web rails db:create db:migrate db:seed

rubocop: ## Runs the Rubocop Linter
	@docker compose run web bundle exec rubocop

rubocop.fix: ## Runs the Rubocop Linter and executes the available autocorrections
	@docker compose run web bundle exec rubocop -A

tests: ## Runs RSpec tests
	@docker compose run web rspec spec

bash: ## Opens the bash inside the container
	@docker compose run web bash

dev.console: ## Opens the Rails console
	@docker compose run web rails c
