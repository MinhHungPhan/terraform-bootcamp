# Makefile for Terraform Providers in Modules Demo

.PHONY: help demo-wrong demo-right clean-wrong clean-right clean-all

help:
	@echo "Terraform Providers in Modules Demo"
	@echo "Available commands:"
	@echo "  demo-wrong    - Run the 'wrong way' demo"
	@echo "  demo-right    - Run the 'right way' demo"
	@echo "  clean-wrong   - Clean up wrong way demo resources"
	@echo "  clean-right   - Clean up right way demo resources"
	@echo "  clean-all     - Clean up all demo resources"
	@echo "  help          - Show this help message"

demo-wrong:
	@echo "Running the 'wrong way' demo..."
	cd demo-wrong-way && terraform init && terraform plan && terraform apply

demo-right:
	@echo "Running the 'right way' demo..."
	cd demo-right-way && terraform init && terraform plan && terraform apply

clean-wrong:
	@echo "Cleaning up 'wrong way' demo resources..."
	cd demo-wrong-way && terraform destroy && rm -rf .terraform* terraform*

clean-right:
	@echo "Cleaning up 'right way' demo resources..."
	cd demo-right-way && terraform destroy && rm -rf .terraform* terraform*

clean-all: clean-wrong clean-right
	@echo "All demo resources cleaned up!"

# Individual terraform commands for each demo
init-wrong:
	cd demo-wrong-way && terraform init

init-right:
	cd demo-right-way && terraform init

plan-wrong:
	cd demo-wrong-way && terraform plan

plan-right:
	cd demo-right-way && terraform plan
