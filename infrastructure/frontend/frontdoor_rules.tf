resource "azurerm_cdn_frontdoor_rule_set" "caching_rules" {
  name                     = "cachingrules"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd.id
}

# Rule 1: SPA Fallback (Priority 1)
# Rewrites any request that doesn't look like a file to /index.html
resource "azurerm_cdn_frontdoor_rule" "spa_rewrite" {
  name                      = "SpaRewrite"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.caching_rules.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    url_rewrite_action {
      source_pattern          = "/"
      destination             = "/index.html"
      preserve_unmatched_path = false
    }
  }

  conditions {
    # If path does NOT have an extension (e.g. /dashboard, /users/1), rewrite it.
    url_file_extension_condition {
      operator     = "LessThan"
      match_values = ["1"]
    }
  }
}

# Rule 2: Cache Images and Fonts (Priority 2)
resource "azurerm_cdn_frontdoor_rule" "cache_images" {
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fd_origin_group,
    azurerm_cdn_frontdoor_origin.fd_origin
  ]
  name                      = "CacheImages"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.caching_rules.id
  order                     = 2
  behavior_on_match         = "Stop"

  conditions {
    url_file_extension_condition {
      operator     = "Equal"
      match_values = ["ico", "png", "jpeg", "jpg", "svg", "woff", "woff2", "ttf"]
    }
  }

  actions {
    route_configuration_override_action {
      compression_enabled           = true
      query_string_caching_behavior = "IgnoreQueryString"
      cache_behavior                = "OverrideAlways"
      cache_duration                = "365.00:00:00"
    }
  }
}

# Rule 3: Cache Code and Data (Priority 3)
resource "azurerm_cdn_frontdoor_rule" "cache_code" {
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.fd_origin_group,
    azurerm_cdn_frontdoor_origin.fd_origin
  ]
  name                      = "CacheCode"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.caching_rules.id
  order                     = 3
  behavior_on_match         = "Stop"

  conditions {
    url_file_extension_condition {
      operator     = "Equal"
      match_values = ["css", "js", "map", "json"]
    }
  }

  actions {
    route_configuration_override_action {
      compression_enabled           = true
      query_string_caching_behavior = "IgnoreQueryString"
      cache_behavior                = "OverrideAlways"
      cache_duration                = "365.00:00:00"
    }
  }
}
