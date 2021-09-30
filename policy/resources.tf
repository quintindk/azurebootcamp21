# Custom naming policy
resource "azurerm_policy_definition" "namingpolicy" {
  name         = "namingPolicy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Naming policy"

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA


  policy_rule = <<POLICY_RULE
{
    "if": {
      "anyOf": [
        {
          "count": {
            "value": [
              "vm",
              "vnet",
              "kv",
              "sql",
              "app",
              "search",
              "ai"
            ],
            "name": "pattern",
            "where": {
              "value": "[split(field('name'), '-')[0]]",
              "like": "[current('pattern')]"
            }
          },
          "notEquals": 1
        },
        {
          "count": {
            "value": [
              "dev",
              "test",
              "prod"
            ],
            "name": "pattern",
            "where": {
              "value": "[split(field('name'), '-')[1]]",
              "like": "[current('pattern')]"
            }
          },
          "notEquals": 1
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE
}

# Custom resource group naming policy
resource "azurerm_policy_definition" "rgnamingpolicy" {
  name         = "rgnamingPolicy"
  policy_type  = "Custom"
  mode         = "Indexed"
  display_name = "Resource group naming policy"

  metadata = <<METADATA
    {
    "category": "General"
    }

METADATA


  policy_rule = <<POLICY_RULE
  {
    "if": {
      "anyOf": [
        {
          "field": "type",
          "equals": "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          "count": {
            "value": [
              "rg"
            ],
            "name": "pattern",
            "where": {
              "value": "[split(field('name'), '-')[0]]",
              "like": "[current('pattern')]"
            }
          },
          "notEquals": 1
        },
        {
          "count": {
            "value": [
              "dev",
              "prod"
            ],
            "name": "pattern",
            "where": {
              "value": "[split(field('name'), '-')[0]]",
              "like": "[current('pattern')]"
            }
          },
          "notEquals": 1
        },
        {
          "count": {
            "value": [
              "southafricanorth",
              "southafricawest",
              "westeurope",
              "northeurope"
            ],
            "name": "pattern",
            "where": {
              "value": "[last(split(field('name'), '-'))]",
              "like": "[current('pattern')]"
            }
          },
          "notEquals": 1
        }
      ]
    },
    "then": {
      "effect": "deny"
    }
  }
POLICY_RULE
}

resource "azurerm_policy_set_definition" "tangent" {
  name         = "tangentPolicySet"
  policy_type  = "Custom"
  display_name = "Tangent Governance MVP"

  # Allowed locations for resource groups
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": ["southafricanorth", "southafricawest", "westeurope", "northeurope"]}
    }
    VALUE
  }

  # Custom naming policy
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.namingpolicy.id
  }

  # Custom resource group naming policy
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.rgnamingpolicy.id
  }
}

data "azurerm_subscription" "sub" {

}

resource "azurerm_subscription_policy_assignment" "custom" {
  name                 = "TangentPolicySet"
  policy_definition_id = azurerm_policy_set_definition.tangent.id
  subscription_id      = data.azurerm_subscription.sub.id
}

resource "azurerm_subscription_policy_assignment" "benchmark" {
  name                 = "SecurityBenchmark"
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
  subscription_id      = data.azurerm_subscription.sub.id
}

# Allowed VM SKUS
resource "azurerm_subscription_policy_assignment" "vmsku" {
  name                 = "VMskus"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/cccc23c7-8427-4f53-ad12-b6a63eb452b3"
  parameters           = <<VALUE
    {
      "listOfAllowedSKUs": {"value": ["Standard_B1ls","Standard_B1ms","Standard_B1s","Standard_B2ms","Standard_B2s","Standard_B4ms","Standard_B8ms",
                                      "Standard_B12ms","Standard_B16ms","Standard_B20ms","Standard_D1_v2","Standard_D2_v2","Standard_D3_v2",
                                      "Standard_D4_v2","Standard_D5_v2","Standard_D11_v2","Standard_D12_v2","Standard_D13_v2","Standard_D14_v2",
                                      "Standard_D15_v2","Standard_D2_v2_Promo","Standard_D3_v2_Promo","Standard_D4_v2_Promo","Standard_D5_v2_Promo",
                                      "Standard_D11_v2_Promo","Standard_D12_v2_Promo","Standard_D13_v2_Promo","Standard_D14_v2_Promo",
                                      "Standard_F1","Standard_F2","Standard_F4","Standard_F8","Standard_F16","Standard_DS1_v2","Standard_DS2_v2",
                                      "Standard_DS3_v2","Standard_DS4_v2","Standard_DS5_v2","Standard_DS11-1_v2","Standard_DS11_v2","Standard_DS12-1_v2",
                                      "Standard_DS12-2_v2","Standard_DS12_v2","Standard_DS13-2_v2","Standard_DS13-4_v2","Standard_DS13_v2","Standard_DS14-4_v2",
                                      "Standard_DS14-8_v2","Standard_DS14_v2","Standard_DS15_v2","Standard_DS2_v2_Promo","Standard_DS3_v2_Promo","Standard_DS4_v2_Promo",
                                      "Standard_DS5_v2_Promo","Standard_DS11_v2_Promo","Standard_DS12_v2_Promo","Standard_DS13_v2_Promo","Standard_DS14_v2_Promo",
                                      "Standard_F1s","Standard_F2s","Standard_F4s","Standard_F8s","Standard_F16s","Standard_A1_v2","Standard_A2m_v2","Standard_A2_v2",
                                      "Standard_A4m_v2","Standard_A4_v2","Standard_A8m_v2","Standard_A8_v2","Standard_D2_v3","Standard_D4_v3","Standard_D8_v3","Standard_D16_v3",
                                      "Standard_D32_v3","Standard_D48_v3","Standard_D64_v3","Standard_D2s_v3","Standard_D4s_v3","Standard_D8s_v3","Standard_D16s_v3",
                                      "Standard_D32s_v3","Standard_D48s_v3","Standard_D64s_v3","Standard_E2_v3","Standard_E4_v3","Standard_E8_v3","Standard_E16_v3",
                                      "Standard_E20_v3","Standard_E32_v3","Standard_E2s_v3","Standard_E4-2s_v3","Standard_E4s_v3","Standard_E8-2s_v3","Standard_E8-4s_v3",
                                      "Standard_E8s_v3","Standard_E16-4s_v3","Standard_E16-8s_v3","Standard_E16s_v3","Standard_E20s_v3","Standard_E32-8s_v3","Standard_E32-16s_v3",
                                      "Standard_E32s_v3","Standard_E48_v3","Standard_E64i_v3","Standard_E64_v3","Standard_E48s_v3","Standard_E64-16s_v3","Standard_E64-32s_v3",
                                      "Standard_E64is_v3","Standard_E64s_v3","Standard_A0","Standard_A1","Standard_A2","Standard_A3","Standard_A5","Standard_A4","Standard_A6",
                                      "Standard_A7","Basic_A0","Basic_A1","Basic_A2","Basic_A3","Basic_A4","Standard_E2_v4","Standard_E4_v4","Standard_E8_v4","Standard_E16_v4",
                                      "Standard_E20_v4","Standard_E32_v4","Standard_E48_v4","Standard_E64_v4","Standard_E2d_v4","Standard_E4d_v4","Standard_E8d_v4","Standard_E16d_v4",
                                      "Standard_E20d_v4","Standard_E32d_v4","Standard_E48d_v4","Standard_E64d_v4","Standard_E2s_v4","Standard_E4-2s_v4","Standard_E4s_v4",
                                      "Standard_E8-2s_v4","Standard_E8-4s_v4","Standard_E8s_v4","Standard_E16-4s_v4","Standard_E16-8s_v4","Standard_E16s_v4","Standard_E20s_v4",
                                      "Standard_E32-8s_v4","Standard_E32-16s_v4","Standard_E32s_v4","Standard_E48s_v4","Standard_E64-16s_v4","Standard_E64-32s_v4","Standard_E64s_v4",
                                      "Standard_E80is_v4","Standard_E2ds_v4","Standard_E4-2ds_v4","Standard_E4ds_v4","Standard_E8-2ds_v4","Standard_E8-4ds_v4","Standard_E8ds_v4",
                                      "Standard_E16-4ds_v4","Standard_E16-8ds_v4","Standard_E16ds_v4","Standard_E20ds_v4","Standard_E32-8ds_v4","Standard_E32-16ds_v4",
                                      "Standard_E32ds_v4","Standard_E48ds_v4","Standard_E64-16ds_v4","Standard_E64-32ds_v4","Standard_E64ds_v4","Standard_E80ids_v4",
                                      "Standard_D2d_v4","Standard_D4d_v4","Standard_D8d_v4","Standard_D16d_v4","Standard_D32d_v4","Standard_D48d_v4","Standard_D64d_v4","Standard_D2_v4",
                                      "Standard_D4_v4","Standard_D8_v4","Standard_D16_v4","Standard_D32_v4","Standard_D48_v4","Standard_D64_v4","Standard_D2ds_v4","Standard_D4ds_v4",
                                      "Standard_D8ds_v4","Standard_D16ds_v4","Standard_D32ds_v4","Standard_D48ds_v4","Standard_D64ds_v4","Standard_D2s_v4","Standard_D4s_v4",
                                      "Standard_D8s_v4","Standard_D16s_v4","Standard_D32s_v4","Standard_D48s_v4","Standard_D64s_v4","Standard_F2s_v2","Standard_F4s_v2",
                                      "Standard_F8s_v2","Standard_F16s_v2","Standard_F32s_v2","Standard_F48s_v2","Standard_F64s_v2","Standard_F72s_v2"
                              ]}
    }
    VALUE
  subscription_id      = data.azurerm_subscription.sub.id
}

# Allowed Storage account SKUS
resource "azurerm_subscription_policy_assignment" "storsku" {
  name                 = "StorageAccountSKUs"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/7433c107-6db4-4ad1-b57a-a76dce0154a1"
  parameters           = <<VALUE
    {
      "listOfAllowedSKUs": {"value": ["Premium_LRS", "Premium_ZRS", "Standard_GRS", "Standard_LRS", "Standard_ZRS"]}
    }
    VALUE
  subscription_id      = data.azurerm_subscription.sub.id
}

# Not allowed resources
resource "azurerm_subscription_policy_assignment" "notallowedres" {
  name                 = "NotAllowedResources"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
  parameters           = <<VALUE
    {
      "listOfResourceTypesNotAllowed": {"value": ["84codes.cloudamqp/listcommunicationpreference","84codes.cloudamqp/operations","84codes.cloudamqp/servers","84codes.cloudamqp/updatecommunicationpreference",
                                                  "crypteron.datasecurity/apps","crypteron.datasecurity/listcommunicationpreference","crypteron.datasecurity/operations","crypteron.datasecurity/updatecommunicationpreference",
                                                  "paraleap.cloudmonix/operations","paraleap.cloudmonix/listcommunicationpreference","paraleap.cloudmonix/services","paraleap.cloudmonix/updatecommunicationpreference",
                                                  "pokitdok.platform/listcommunicationpreference","pokitdok.platform/operations","pokitdok.platform/services","pokitdok.platform/updatecommunicationpreference",
                                                  "ravenhq.db/databases","ravenhq.db/listcommunicationpreference","ravenhq.db/updatecommunicationpreference","ravenhq.db/operations","raygun.crashreporting/apps",
                                                  "raygun.crashreporting/listcommunicationpreference","raygun.crashreporting/operations","raygun.crashreporting/updatecommunicationpreference","wandisco.fusion/fusiongroups",
                                                  "wandisco.fusion/fusiongroups/azurezones/plugins","wandisco.fusion/fusiongroups/azurezones","wandisco.fusion/fusiongroups/hivereplicationrules","wandisco.fusion/fusiongroups/managedonpremzones",
                                                  "wandisco.fusion/fusiongroups/replicationrules","wandisco.fusion/fusiongroups/replicationrules/migrations","wandisco.fusion/locations","wandisco.fusion/migrators",
                                                  "wandisco.fusion/locations/operationstatuses","wandisco.fusion/migrators/exclusiontemplates","wandisco.fusion/migrators/livedatamigrations","wandisco.fusion/migrators/metadatamigrations",
                                                  "wandisco.fusion/migrators/metadatatargets","wandisco.fusion/migrators/pathmappings","wandisco.fusion/migrators/targets","wandisco.fusion/operations"]
                              }             
    }
    VALUE
  subscription_id      = data.azurerm_subscription.sub.id
}

# NICs should not have public IPs by default
resource "azurerm_subscription_policy_assignment" "nicip" {
  name                  = "NIC no default public IP"
  policy_definition_id  = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
  subscription_id      = data.azurerm_subscription.sub.id
}       

# Select Standard Security Centre tier
resource "azurerm_subscription_policy_assignment" "scstd" {
  name                  = "Select SC Standard tier"
  policy_definition_id  = "/providers/Microsoft.Authorization/policyDefinitions/a1181c5f-672a-477a-979a-7d58aa086233"
  subscription_id      = data.azurerm_subscription.sub.id
}