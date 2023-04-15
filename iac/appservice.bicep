param calculatedprefix string
param sku string = 'F1' // The SKU of App Service Plan
param location string = resourceGroup().location
var appServicePlanName = toLower('asp-${calculatedprefix}')
var webSiteName = toLower('wapp-${calculatedprefix}')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      acrUseManagedIdentityCreds: true
      appSettings: [
      {
        name: 'DOCKER_REGISTRY_SERVER_URL'
        value: 'acrxpirits4m5qo5xd3f4a.azurecr.io'
      }]
      linuxFxVersion: 'DOCKER|acrxpirits4m5qo5xd3f4a.azurecr.io/wordyapi:latest'
    }
  }
}

output app_principalId string = appService.identity.principalId
