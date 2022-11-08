ohmyzsh: ohmyzsh-install ohmyzsh-configure ## Install and configure Oh My Zsh
ohmyzsh-install: ## Install Oh My Zsh
	@./scripts/ohmyzsh.sh install
ohmyzsh-configure: ## Configure Oh My Zsh
	@./scripts/ohmyzsh.sh configure