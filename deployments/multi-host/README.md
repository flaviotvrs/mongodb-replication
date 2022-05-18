# MongoDB Replication : Multi host deployment

## Provision Infrastructure

```
terraform -chdir=./infra/ init
terraform -chdir=./infra/ apply --var-file=../deployments/multi-host/infra/terraform.tfvars --state=../deployments/multi-host/infra/terraform.tfstate
```