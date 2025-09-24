.PHONY: help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.PHONY: init
init: ## Initialize Terraform
	terraform init

.PHONY: validate
validate: ## Validate Terraform configuration
	terraform validate

.PHONY: fmt
fmt: ## Format Terraform files
	terraform fmt -recursive

.PHONY: fmt-check
fmt-check: ## Check Terraform formatting
	terraform fmt -check -recursive

.PHONY: plan
plan: ## Run Terraform plan
	terraform plan

.PHONY: apply
apply: ## Run Terraform apply
	terraform apply

.PHONY: destroy
destroy: ## Run Terraform destroy
	terraform destroy

.PHONY: docs
docs: ## Generate documentation
	terraform-docs markdown table --output-file README.md --output-mode inject .

.PHONY: lint
lint: ## Run linters
	tflint
	tfsec .

.PHONY: test
test: validate fmt-check lint ## Run all tests

.PHONY: pre-commit
pre-commit: ## Run pre-commit hooks
	pre-commit run --all-files

.PHONY: pre-commit-install
pre-commit-install: ## Install pre-commit hooks
	pre-commit install

.PHONY: clean
clean: ## Clean up temporary files
	rm -rf .terraform
	rm -f .terraform.lock.hcl
	rm -f terraform.tfstate*
	rm -f .terraform.tfstate.lock.info

.PHONY: security
security: ## Run security scans
	tfsec .
	trivy fs .
	checkov -d . --framework terraform

.PHONY: examples
examples: ## Test examples
	@for example in examples/*/; do \
		echo "Testing $$example"; \
		cd $$example && terraform init -backend=false && terraform validate && cd -; \
	done
