locals {
  # Calculate a hash of all file contents in the source directory.
  # We use robust globbing by merging file lists instead of brace expansion which can be flaky.
  src_files    = fileset(var.frontend_source_path, "src/**/*")
  public_files = fileset(var.frontend_source_path, "public/**/*")
  config_files = fileset(var.frontend_source_path, "package.json")
  vite_config  = fileset(var.frontend_source_path, "vite.config.ts")
  html_file    = fileset(var.frontend_source_path, "index.html")

  all_files = setunion(local.src_files, local.public_files, local.config_files, local.vite_config, local.html_file)

  source_files_hash = sha1(join("", [for f in local.all_files : file("${var.frontend_source_path}/${f}")]))
}

# 1. Generate the .env.local file needed for the build
resource "local_file" "env_local" {
  content  = <<EOT
VITE_CLIENTID=${var.vite_client_id}
VITE_TENANTID=${var.vite_tenant_id}
VITE_API_SCOPE_URI=${var.vite_api_scope_uri}
EOT
  filename = "${var.frontend_source_path}/.env.local"
}

resource "null_resource" "frontend_build_deploy" {
  triggers = {
    # Trigger a build when source files change
    source_code_hash = local.source_files_hash
    # Also trigger if environment variables change
    env_vars_hash = sha1(local_file.env_local.content)
    # Also trigger if the storage account changes
    storage_account = azurerm_storage_account.web_storage.id
  }

  provisioner "local-exec" {
    # The command sequence:
    # 1. Navigate to source dir and install/build
    # 2. Upload to relevant storage account
    command = <<EOT
      cd ${var.frontend_source_path} && \
      npm install && \
      npm run build && \
      az storage blob upload-batch \
        --destination '$web' \
        --source ./dist \
        --account-name ${azurerm_storage_account.web_storage.name} \
        --overwrite
    EOT

    # Use quiet mode for npm to reduce log spam, but show errors
    environment = {
      CI = "true"
    }
  }

  # Ensure the .env.local file exists BEFORE trying to build
  depends_on = [local_file.env_local]
}
