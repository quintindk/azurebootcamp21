# Setup GitHub secrets for the Repo

This folder contains the Terraform to create the environment secrets that will be used by the Github actions.

## Getting Started

Getting the code up and running on your own system.

1. Install terraform from [here](https://www.terraform.io/downloads.html)
2. Install az-cli from [here]
3. Login to azure `az login`
4. Set to the correct subscription `az account set --subscription <subs_id>`

## Usage

Create a file called `.dev.tfvars`

```terraform
environment=""
client_id=""
tenant_id=""
client_secret=""
subscription_id=""
```

To validate your terraform.

```bash
terraform init
terraform validate
```

To load your secrets.

```bash
terraform apply -var-file .dev.tfvars
```
