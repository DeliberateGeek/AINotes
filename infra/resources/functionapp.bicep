param name string
param location string = resourceGroup().location
param tags object = {}

// Reference Properties
param appServicePlanId string
param storageAccountName string

// Microsoft.Web/sites Properties
param kind string = 'functionapp'
param functionWebsiteContentShareName string

//Ref to existing storage account
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

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

resource appSettingsConfig 'Microsoft.Web/sites/config@2022-09-01' ={
  name: 'appsettings'
  parent: functionApp
  properties: {
    AzureWebJobsStorage: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: 'dotnet'
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=core.windows.net'
    WEBSITE_CONTENTSHARE: functionWebsiteContentShareName
  }
}

output identityPrincipalId string = functionApp.identity.principalId
output name string = functionApp.name
output uri string = 'https://${functionApp.properties.defaultHostName}'
