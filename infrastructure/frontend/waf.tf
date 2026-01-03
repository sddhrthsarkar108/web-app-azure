resource "azurerm_cdn_frontdoor_firewall_policy" "waf" {
  name                              = "waf${lower(replace(var.app_name, "_", ""))}${var.environment}"
  resource_group_name               = var.resource_group_name
  sku_name                          = "Premium_AzureFrontDoor"
  enabled                           = true
  mode                              = "Prevention"
  custom_block_response_status_code = 403
  custom_block_response_body        = "Zm9yYmlkZGVu" # "forbidden" in base64

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_security_policy" "waf_association" {
  name                     = "sec-pol-${var.environment}"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.fd_endpoint.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
