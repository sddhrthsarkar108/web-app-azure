resource "null_resource" "approve_private_endpoint" {
  triggers = {
    origin_id = azurerm_cdn_frontdoor_origin.fd_origin.id
  }

  depends_on = [azurerm_cdn_frontdoor_origin.fd_origin]

  provisioner "local-exec" {
    command     = <<EOT
      az network private-endpoint-connection approve \
        --id $(az network private-endpoint-connection list \
          --name ${azurerm_storage_account.web_storage.name} \
          --resource-group ${var.resource_group_name} \
          --type Microsoft.Storage/storageAccounts \
          --query "[?properties.privateLinkServiceConnectionState.status=='Pending'].id" -o tsv) \
        --description "Auto-approved by Terraform"
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
