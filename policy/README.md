# Policies

The Cloud Adoption Framework provides governance guides that describe the experiences of fictional companies that are based on the experiences of real customers. Each guide follows the customer through the governance aspects of their cloud adoption.The Governance model identifies key areas of importance during the journey. Each area relates to different types of risks the company must address as it adopts more cloud services. Within this framework, the governance guide identifies required actions for the cloud governance team.

Five Disciplines of Cloud Governance: These disciplines support the corporate policies. Each discipline protects the company from potential pitfalls:

* Cost Management discipline
* Security Baseline discipline
* Resource Consistency discipline
* Identity Baseline discipline
* Deployment Acceleration discipline

## Cost Management

As part of the Cost management discipline the following Policies where put in place at the Subscription level. These should be extended further to your cloud adoption at a subscription and management group level.

1. Allowed Locations - limited to `southafricanorth`, `southafricawest`, `westeurope` and `northeurope`. Europe is included for scenarios where the resource types are not available in the African geography.
2. Allowed Resource Types - limited to the architectural components listed above.
3. Allowed Storage SKUs - limited to Standard LRS accounts.

## Security Baseline

The security discipline required the following policies be included. These are the baseline policies for the components that were listed and include ensuring that publicly accessible services access is limited using the service firewalls. This can be tightened up further with the introduction of Private Endpoints when a Site-to-Site VPN is introduced.

1. Azure Security Center - providing baseline security governance for Azure Security Center.
2. Azure Security Baseline - providing Audit reports to indicate security compliance.

Also, Azure Security Center standard will be enabled. Defender can be enabled for individual resource types and should be enabled but all resource types disabled at the start.

## Resource Consistency

The resource consistency baseline is all about the naming and tagging conventions that will be used on the resources to ensure that they are consistent in all aspects. The following diagram shows the resource naming convention that will be implemented. For full list of abbreviations have a look at [https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)

The following list provides a high level guideline for the components deployed.

`rg-<app or service name>-<environment>-<location>`

The following list provides a high level guideline for the components deployed that allow `-` characters.

`asp-<app or service name>-<environment>`

`app-<app or service name>-<environment>`

`func-<app or service name>-<environment>`

`search-<app or service name>-<environment>`

`sqlserver-<app or service name>-<environment>`

`database-<app or service name>-<environment>`

The following show examples of services where `-` are not allowed.

`acr<app or service name><environment>`

`stor<app or service name><environment>`

Another aspect of resource consistency is tagging which is also part of cost management and security The minimum tagging should be according to the best practices [here](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-tagging#minimum-suggested-tags).

The following policy requires that the following tags are implemented on all resources groups:

* WorkloadName
* Approver
* Owner
* Requester
* BudgetAmount
* Environment
* Location

The following policy requires that the following tags are implemented on all resources **all tags should be inherited from resource groups**:

* ApplicationName
* OpsTeam
* OpsCommitment
* BusinessUnit
* Criticality
* DR
* DataSubject
* DataOperator
* StartDate
* EndDate

## Identity Baseline

The Identity Baseline discipline is specifically implemented according to the Least Privilege Principals of Defense in Depth. The following principals, groups and assignments are implemented:

### Principals

1. Web Application Users - Business users
2. App Service - SystemAssigned
3. Search Service - SystemAssigned

### Groups

1. Owners - **TODO**
2. Users - **TODO**
3. SQL Admins - **TODO**

### Assignments

| Resource               | Role   | Group/User Principal |
|:-----------------------|:-------|:---------------------|
| Resource Group         | Owner  | Resource Owners      |
| Blob Storage           | Reader | Users                |
| SQL Database           | Reader | Function App         |
| App Service Plan       |        |                      |
| App Service            | Reader | Web Application      |
| Function App           | Caller | Search Service       |
| Key Vault              | Reader | Web Application      |
| Application Insights   |        |                      |
| Azure Cognitive Search | Reader | Web Application      |

## Deployment Acceleration

The deployment acceleration discipline speaks to the automation of deployments and in that sense the terraform scripts provided are a form of deployment acceleration.

## Azure Policies

In order to adhere to this governance strategy, the following policies are defined and assigned in this repository:

• Allowed resource group locations (SAN, SAW, NEU, WEU) (Mode: Deny)
• Resource naming convention (Mode: Deny)
• Resource group naming convention (Mode: Deny)
• Azure Security Centre benchmark initiative
• Allowed VM SKUs (Everything smaller or including F-series VMs) (Mode: Deny)
• Allowed storage account SKUs (Mode: Deny)
• Not allowed resources (All MS and Sendgrid resources allowed) (Mode: Deny)
• NICs should not have public Ips by default
• Azure Security Standard tier must be selected

Currently, most policies are assigned individually to simplify policy parameterization.