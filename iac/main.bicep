param prefix string
param location string = resourceGroup().location

var calculatedprefix = '${prefix}${uniqueString(resourceGroup().id)}'

module storage './storage.bicep' = {
  name: 'storage'
  params: {
    calculatedprefix: calculatedprefix
    accountType: 'Standard_LRS'
    location: location
  }
}

module appservice './appservice.bicep' = {
  name: 'appservice'
  params: {
    calculatedprefix: calculatedprefix
    sku: 'B1'
    location: location
  }
}

module containerregistry './containerregistry.bicep' = {
  name: 'containerregistry'
  params: {
    calculatedprefix: calculatedprefix
    acrSku: 'Basic'
    location: location
  }
}

module cosmosdb './cosmosdb.bicep' = {
  name: 'cosmosdb'
  params: {
    calculatedprefix: calculatedprefix
    primaryRegion: location
    defaultConsistencyLevel: 'Session'
    databaseName: 'wordydb'
    containerName: 'dictionary'
    location: location
  }
}
