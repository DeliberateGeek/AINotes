param name string
param location string = resourceGroup().location
param tags object = {}

// Reference Properties
param appServicePlanId string

// Microsoft.Web/sites Properties
param kind string = 'functionapp'

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: name
  kind: kind
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    httpsOnly: true
    publicNetworkAccess: 'Enabled'
    serverFarmId: appServicePlanId
  }
}

output identityPrincipalId string = functionApp.identity.principalId
output name string = functionApp.name
output uri string = 'https://${functionApp.properties.defaultHostName}'
