param location string = resourceGroup().location

param functionAppPrincipalId string
param functionAppName string
param tags object
param keyVaultName string
param keyVaultsku object = {
  name: 'standard'
  family: 'A'
}

var roleDefinitionIds = loadJsonContent('../roleDefinitionIds.json')

module sharedKeyVault '../resources/keyvault.bicep' = {
  name: '${keyVaultName}-deployment'
  params: {
    name: keyVaultName
    location: location
    tags: tags
    sku: keyVaultsku
  }
}

module keyVaultSecretAccessForFunctionApp '../resources/role-assignment.bicep' ={
  name: '${keyVaultName}-${functionAppName}-roleAssignment'
  params: {
    principalId: functionAppPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: roleDefinitionIds.KeyVaultSecretsUser
  }
}
