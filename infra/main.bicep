targetScope = 'subscription'

@minLength(1)
@maxLength(10)
@description('Name of the the project which is used to generate a short unique hash used in all resources.')
param projectName string = 'ainote'

@minLength(1)
@maxLength(10)
@description('Name of the the environment which is used to generate a short unique hash used in all resources.')
@allowed(['dev','test','prod','poc'])
param environmentName string

//Limit the allowed values for the location parameter to ones where OpenAI is available
@minLength(1)
@allowed(['eastus','southcentralus'])
@description('Primary location for all resources')
param location string = 'eastus'

var abbrs = loadJsonContent('abbreviations.json')

var mainModuleName = 'ainote'
var sharedRgName = toLower('${abbrs.resourcesResourceGroups}-${projectName}-shared-${environmentName}')
var mainRgName = toLower('${abbrs.resourcesResourceGroups}-${projectName}-${mainModuleName}-${environmentName}')
var mainStorageAccountName = toLower('${abbrs.storageStorageAccounts}-${projectName}-${mainModuleName}-${environmentName}')
var mainFunctionStorageContainerName = 'function-storage'
var mainFunctionAudioFilesContainerName = 'audio-files'
var mainFunctionTranscriptionsContainerName = 'transcriptions'
var mainFunctionSummariesContainerName = 'summaries'

var tags = {project: projectName, environment: environmentName, contact: 'Steve Brouillard'}

resource sharedRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: sharedRgName
  location: location
  tags: tags
}

resource mainRg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: mainRgName
  location: location
  tags: tags
}
