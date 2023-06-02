param location string = resourceGroup().location

param tags object
param storageAccountName string
param storageBlobContainers array
param storageDeleteRetentionPolicy object = { 
  enabled: true
  days: 5
}

param appServicePlanName string
param functionAppName string


module mainStorageAccount '../resources/storage-account.bicep' = {
  name: '${storageAccountName}-deployment'
  params: {
    location: location
    name: storageAccountName
    tags: tags
    deleteRetentionPolicy: storageDeleteRetentionPolicy
    containers: storageBlobContainers
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


