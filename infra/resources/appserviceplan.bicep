param name string
param location string = resourceGroup().location
param tags object = {}
param sku object = {
  name: 'Y1'
  tier: 'Dynamic'
}
param kind string = 'functionapp'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  location: location
  tags: tags
  sku: sku
  kind: kind
  properties: {
    
  }
}

output id string = appServicePlan.id
output name string = appServicePlan.name
