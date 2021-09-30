# Azure Bootcamp 21

This repository contains the code from the Azure Bootcamp 21 South Africa conference where I presented Azure Policy as Code.

## Installation

Getting the code up and running on your own system.

1. Install terraform from [here](https://www.terraform.io/downloads.html)
2. Install az-cli from [here]
3. Login to azure `az login`
4. Set to the correct subscription `az account set --subscription <subs_id>`

## Usage

To validate your terraform before committing to the repository you can follow steps.

```bash
cd policy
terraform init -backend=false
terraform validate
```

If you would like to check the effects of the changes you can run an plan using the following commands.

```bash
terraform init -backend-config "resource_group_name=rg-terraform-southafricanorth" -backend-config "storage_account_name=quintinterraform" -backend-config "container_name=tfstate" -backend-config "key=azuredemo.terraform.tfstate"
terraform workspace select dev
terraform plan -var-file dev.tfvars
```

> **DO NOT APPLY THE PLAN**. The plan and apply will be run by the pipeline for each environment in sequence and the plans will require approval before they can be applied.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)