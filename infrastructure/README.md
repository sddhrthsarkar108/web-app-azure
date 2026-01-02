### Upload UI Distribution
```sh
STORAGE_NAME=$(terraform -chdir=infrastructure output -raw storage_account_name)
CONTAINER_NAME=$(terraform -chdir=infrastructure output -raw storage_container_name)
  
echo "Storage: $STORAGE_NAME"     
echo "Container: $CONTAINER_NAME"


siddhartha.sarkar@Q7WHFQ64T4 web-app-azure % az storage blob upload-batch \                                                  
  --account-name $STORAGE_NAME \
  --destination $CONTAINER_NAME \
  --source testReact.client/dist \
  --overwrite \
  --auth-mode login
  ```