param name string
param location string = resourceGroup().location
param tags object = {}

@allowed([ 'Hot', 'Cool', 'Premium' ])
param accessTier string = 'Hot'
param allowBlobPublicAccess bool = true
param allowSharedKeyAccess bool = true //Allow Shared Key access to the storage account for functions
param defaultToOAuthAuthentication bool = false
param deleteRetentionPolicy object = {}
param kind string = 'StorageV2'
param minimumTlsVersion string = 'TLS1_2'
@allowed([ 'Enabled', 'Disabled' ])
param publicNetworkAccess string = 'Enabled'
param sku object = { 
  name: 'Standard_LRS'
  tier: 'Standard'
}

param includeBlobServices bool = true
param includeFileServices bool = true
param includeQueueServices bool = true
param includeTableServices bool = true

param containers array = []
param shares array = []

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: name
  location: location
  tags: tags
  kind: kind
  sku: sku
  properties: {
    accessTier: accessTier
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    defaultToOAuthAuthentication: defaultToOAuthAuthentication
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    minimumTlsVersion: minimumTlsVersion
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Allow'
    }
    publicNetworkAccess: publicNetworkAccess
    
    supportsHttpsTrafficOnly: true
  }

  resource blobServices 'blobServices' = if (includeBlobServices) {    
    name: 'default'
    properties: {
      deleteRetentionPolicy: deleteRetentionPolicy
    }
    resource container 'containers' = [for container in containers: if(!empty(containers)) {
      name: container.name
      properties: {
        immutableStorageWithVersioning: {
          enabled: false
        }
        defaultEncryptionScope: '$account-encryption-key'
        denyEncryptionScopeOverride: false
        publicAccess: 'None'
      }
    }]
  }

  resource fileServices 'fileServices' = if (includeFileServices) {
    name: 'default'
    properties: {
      shareDeleteRetentionPolicy: deleteRetentionPolicy
    }
    resource share 'shares' = [for share in shares: if(!empty(shares)) {
      name: share.name
      properties: {
        accessTier: 'TransactionOptimized'
        shareQuota: 5120
        enabledProtocols: 'SMB'
      }
    }]
  }

  resource queueServices 'queueServices' = if (includeQueueServices) {
    name: 'default'
  }

  resource tableServices 'tableServices' = if (includeTableServices) {
    name: 'default'
  }
}

output name string = storage.name
output primaryEndpoints object = storage.properties.primaryEndpoints
output id string = storage.id
output apiVersion string = storage.apiVersion
