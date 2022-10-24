# this makefile can be run from the root folder to install all modules at once, or it can be run in the module folders to setup individually
ifneq (,$(wildcard .env))
    $(info Exported .env file in this folder)

    include .env
    export
else
    $(info You should have an .env file in this folder)
    exit-make:
endif


.PHONY: all plan apply destroy

all: help

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'

help:								## Show makefile help    
	$(info ---------------------  ${DEV_ENV_NAME} --------------------)
	$(info Cluster Name     : ${DEV_ENV_NAME})
	$(info Environment Name : ${DEV_ENV_NAME})
	$(info --------------------------------------------------------)
	$(info Command in this makefile are listed below.)
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

project-init:							## Intialize a new cluster setup project
	figlet ${CLUSTER_NAME} PROJECT INIT
	cp terraform.tfvars $${TF_VAR_cluster_tfvars}
toolset:							## Installs necessary tools to your machine
	$(info TOOLSET INSTALLATION)
	sh ./scripts/toolset.sh
init:				verify-cloud-set		## Initialize remote S3 backend.
	figlet ${CLUSTER_NAME} INIT
	terraform init -backend-config="prefix=$$(basename $$(pwd))" -backend-config="bucket=$${TF_VAR_aws_bucket_tf_state}" -var-file="../../$${TF_VAR_cluster_tfvars}"

init-reconfigure:		verify-cloud-set		## Initialize remote S3 backend. Use if you just cloned and want to retrieve remote state.
	figlet ${CLUSTER_NAME} INIT RC
	terraform init -reconfigure -backend-config="prefix=$$(basename $$(pwd))" -backend-config="bucket=$${TF_VAR_aws_bucket_tf_state}" -var-file="../../$${TF_VAR_cluster_tfvars}"

init-migrate-state:		verify-cloud-set		## Initialize remote S3 backend.
	figlet ${CLUSTER_NAME} INIT MS
	terraform init -migrate-state -backend-config="prefix=$$(basename $$(pwd))" -backend-config="bucket=$${TF_VAR_aws_bucket_tf_state}" -var-file="../../$${TF_VAR_cluster_tfvars}"

plan:				verify-cloud-set		## Plan the changes to infra.
	figlet ${CLUSTER_NAME} PLAN
	terraform plan -var "component_name=$$(basename $$(pwd))" -var-file="../../$${TF_VAR_cluster_tfvars}"

plan-lock-false:		verify-cloud-set		## Plan the changes to infra. (STATE CORRUPTION EMINENT)
	figlet ${CLUSTER_NAME} PLAN LF
	terraform plan -lock=false -var "component_name=$$(basename $$(pwd))" -var-file="../../$${TF_VAR_cluster_tfvars}"

refresh:			verify-cloud-set		## Refresh the remote state with existing AWS infra.
	figlet ${CLUSTER_NAME} REFRESH
	terraform refresh -var "component_name=$$(basename $$(pwd))" -var-file="../../$${TF_VAR_cluster_tfvars}"

apply:				verify-cloud-set		## Apply the changes in plan.
	figlet ${CLUSTER_NAME} APPLY
	terraform apply -auto-approve -var "component_name=$$(basename $$(pwd))" -var-file="../../$${TF_VAR_cluster_tfvars}"

output:				verify-cloud-set		## See the output.
	figlet ${CLUSTER_NAME} OUTPUT
	terraform output -json

tls-update:			verify-cloud-set		## See the output.
	figlet ${CLUSTER_NAME} TLS UPDATE
	terraform apply -compact-warnings -target=kubernetes_secret.secret_tls -auto-approve -var "component_name=$$(basename $$(pwd))" -var-file="../../$${TF_VAR_cluster_tfvars}"

destroy:			verify-cloud-set		## Destroy the infra.
	figlet ${CLUSTER_NAME} DESTROY
	terraform destroy -auto-approve -var "component_name=$$(basename $$(pwd))" -var-file="../../$${TF_VAR_cluster_tfvars}"

destroy-lock-false:		verify-cloud-set		## Destroy the infra. (STATE CORRUPTION EMINENT)
	figlet ${CLUSTER_NAME} DESTROY LF
	terraform destroy -lock=false -auto-approve -var "component_name=$$(basename $$(pwd))" -var-file="../../$${TF_VAR_cluster_tfvars}"

e2e:				verify-cloud-set init plan apply output destroy 		## Build & Destroy. End To End


exit-make:											## Exit makefile
	$(info Exiting)


verify-cloud-set:
ifndef TF_VAR_aws_bucket_tf_state
	$(error TF_VAR_aws_bucket_tf_state is not defined. Make sure that you set TF_VAR_aws_bucket_tf_state in repo's /k8s/.env)
endif


