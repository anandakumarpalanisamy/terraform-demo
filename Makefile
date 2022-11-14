ENV_NAME=
REGION=eu-west-1
S3ENCRYPT=true
PROJECT_NAME=azzurri-pat

init:
	terraform init -upgrade

clean:
	rm -rf .terraform terraform.tfstate terraform.tfstate.backup

plan:
	terraform plan -refresh=true -var-file=params/${ENV_NAME}.tfvars

apply:
	terraform apply -var-file=params/${ENV_NAME}.tfvars

refresh:
	terraform refresh -var-file=params/$(ENV_NAME).tfvars 

destroy:
	terraform destroy -var-file=params/$(ENV_NAME).tfvars
