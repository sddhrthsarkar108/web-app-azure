resource "azurerm_cdn_frontdoor_rule_set" "spa_rules" {
  name                     = "sparules"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

# Rule 1: Fallback Logic (Rewrite root and routes to index.html)
resource "azurerm_cdn_frontdoor_rule" "spa_rewrite" {
  # FIX 1: Use 'depends_on' (Terraform meta-argument), not 'dependencies'
  depends_on = [azurerm_cdn_frontdoor_origin.fd_origin]

  name                      = "SpaRewrite"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.spa_rules.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    url_rewrite_action {
      source_pattern          = "/"
      destination             = "/content/index.html"
      preserve_unmatched_path = false
    }
  }

  conditions {
    # FIX 2: Correct block name is 'url_file_extension_condition'
    url_file_extension_condition {
      operator     = "LessThan"
      match_values = ["1"]
    }
  }
}

# Rule 2: Asset Logic (Rewrite valid files to /content/ folder)
resource "azurerm_cdn_frontdoor_rule" "assets_rewrite" {
  name                      = "AssetsRewrite"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.spa_rules.id
  order                     = 2
  behavior_on_match         = "Continue"

  actions {
    url_rewrite_action {
      source_pattern          = "/"
      destination             = "/content/"
      preserve_unmatched_path = true
    }
  }

  conditions {
    # FIX 3: Correct block name here as well
    url_file_extension_condition {
      operator     = "GreaterThan"
      match_values = ["0"]
    }
  }
}