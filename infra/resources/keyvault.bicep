param name string
param location string = resourceGroup().location
param tags object = {}
param sku object = {
  name: 'standard'
  family: 'A'
}

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: sku
    tenantId: subscription().tenantId
    enabledForDeployment: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
  }
}
