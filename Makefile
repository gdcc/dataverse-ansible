.PHONY: bootstrap
bootstrap:
	ansible-galaxy collection install -r collections/requirements.yml -p ./collections --force
