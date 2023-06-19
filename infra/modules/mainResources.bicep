param location string = resourceGroup().location

param tags object
param storageAccountName string
param storageBlobContainers array
param storageFileShares array
param storageDeleteRetentionPolicy object = { 
  enabled: true
  days: 5
}

param appServicePlanName string
param functionAppName string
param functionWebsiteContentShareName string


module mainStorageAccount '../resources/storage-account.bicep' = {
  name: '${storageAccountName}-deployment'
  params: {
    location: location
    name: storageAccountName
    tags: tags
    deleteRetentionPolicy: storageDeleteRetentionPolicy
    containers: storageBlobContainers
    shares: storageFileShares
  }
}

module mainFunctionAppServicePlan '../resources/appserviceplan.bicep' = {
  name: '${appServicePlanName}-deployment'
  params: {
    location: location
    name: appServicePlanName
    tags: tags
  }
}

module mainFunctionApp '../resources/functionapp.bicep' = {
  name: '${functionAppName}-deployment'
  params: {
    location: location
    name: functionAppName
    tags: tags
    appServicePlanId: mainFunctionAppServicePlan.outputs.id
    storageAccountName: mainStorageAccount.outputs.name
    functionWebsiteContentShareName: functionWebsiteContentShareName
  }
}

output functionAppPrincipalId string = mainFunctionApp.outputs.identityPrincipalId
