param location string = resourceGroup().location

param tags object
param keyVaultName string
param keyVaultsku object = {
  name: 'standard'
  family: 'A'
}

module sharedKeyVault '../resources/keyvault.bicep' = {
  name: '${keyVaultName}-deployment'
  params: {
    name: keyVaultName
    location: location
    tags: tags
    sku: keyVaultsku
  }
}
