﻿# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
<#
 .SYNOPSIS
    Deploys the AzureFoundation templates for Site 1 and 2 of a four datacenter pattern.  The metadata template that 
    created this template refers to these VNETs as VNET300 through VNET 404.


  
 .DESCRIPTION
    Deploys an Azure Resource Manager template assocazted to the first site in the AzureFoundation

    VNETID Naming Conventions
    
    VNET100:  Production Site 1
    VNET301:  HBI Site 1
    VNET302:  PreProd Site 1
    VNET303:  Storage Site 1
    VNET304:  Services Site 1

    VNET400:  Production Site 1
    VNET401:  HBI Site 1
    VNET402:  PreProd Site 1
    VNET403:  Storage Site 1
    VNET404:  Services Site 1

 .PARAMETERs 
    subscriptionId_prod
    The subscription ids where the template will be deployed.

 .PARAMETER resourceGroupName
    The resource group where the template will be deployed. Can be the name of an existing or a new resource group.

 .PARAMETER resourceGroupLocation
    Optional, a resource group location. If specified, will try to create a new resource group in this location. If not specified, assumes resource group is existing.

 .PARAMETER deploymentName
    The deployment name.

 .PARAMETER templateFilePath
    Optional, path to the template file. Defaults to template.json.

 .PARAMETER parametersFilePath
    Optional, path to the parameters file. Defaults to parameters.json. If file is not found, will prompt for parameter txlues based on template.
#>

Function RegisterRP {
    Param(
        [string]$ResourceProviderNamespace
    )

    Write-Host "Registering resource provider '$ResourceProviderNamespace'";
    Register-AzureRmResourceProvider -ProviderNamespace $ResourceProviderNamespace;
}

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# sign in
Write-Host "Logging in...";
$Environment = "AzureUSGovernment"
#$Environment = 'AzureCloud'
Login-AzureRmAccount -EnvironmentName $Environment;


#In these variables, use the Get-AzureRMSubscription command to list the subscriptions 
#Cut and Paste the values in the variables for the five standard subscriptions.
$UserName='willst@mag.msftgov.us'
#Use the Subscription Tab of the spreadsheet to copy the values here for the subscription variables.
$subID_Prod="4a0d1d83-f557-4065-8423-be499038298a"
$subID_HBI="97eba262-9086-4a3e-9770-dcfef6c3df30"
$subID_PreProd="a4b962d2-6b17-4c38-af02-010a6e774379"
$subID_Storage="0223b7af-344f-42cd-bed2-5ebbc7d06d5d"
$subID_Services="30457dd5-e56b-416b-9228-d48b37fe7caa"


#Update these fields for the datacenter pair to target the deployment at
#https://docs.microsoft.com/en-us/azure/best-practices-availability-paired-regions
#Goto the Location Tab and select the PowerShell for the Region that will be Site 1 and Site 2

$locationSite_3="usgovtexas"
$locationSite_4="usgovarizona"


#using the spreadsheet goto the VNET tab and copy the computed ResourceGroup Names.

$ResourceGroupName_vnet300="rg_network_vnet1a_prod_tx"
$ResourceGroupName_vnet301="rg_network_vnet1a_hbi_tx"
$ResourceGroupName_vnet302="rg_network_vnet1a_preprod_tx"
$ResourceGroupName_vnet303="rg_network_vnet1a_storage_tx"
$ResourceGroupName_vnet304="rg_network_vnet1a_services_tx"
$ResourceGroupName_vnet400="rg_network_vnet1a_prod_az"
$ResourceGroupName_vnet401="rg_network_vnet1a_hbi_az"
$ResourceGroupName_vnet402="rg_network_vnet1a_preprod_az"
$ResourceGroupName_vnet403="rg_network_vnet1a_storage_az"
$ResourceGroupName_vnet404="rg_network_vnet1a_services_az"


#Setup the Deployment Name
$date=Get-Date
$deploymentName = "AzureFoundation" + $date.month + $date.day + $date.Year

#Setup where the template files can be found
$RootPath = "C:\Users\WILLS\Source\Repos\AzureFoundation\ARM\Networking"

$ParametersPathVNET300=$RootPath+"\Site3\af_vnet_azuredeploy_parameters_Site3_prod_A.json"
$TemplatePathVNET300=$RootPath+"\Site3\af_vnet_azuredeploy_template_Site3_prod_A.json"
$ParametersPathVNET301=$RootPath+"\Site3\af_vnet_azuredeploy_parameters_Site3_hbi_A.json"
$TemplatePathVNET301=$RootPath+"\Site3\af_vnet_azuredeploy_template_Site3_hbi_A.json"
$ParametersPathVNET302=$RootPath+"\Site3\af_vnet_azuredeploy_parameters_Site3_preprod_A.json"
$TemplatePathVNET302=$RootPath+"\Site3\af_vnet_azuredeploy_template_Site3_preprod_A.json"
$ParametersPathVNET303=$RootPath+"\Site3\af_vnet_azuredeploy_parameters_Site3_storage_A.json"
$TemplatePathVNET303=$RootPath+"\Site3\af_vnet_azuredeploy_template_Site3_storage_A.json"
$ParametersPathVNET304=$RootPath+"\Site3\af_vnet_azuredeploy_parameters_Site3_services_A.json"
$TemplatePathVNET304=$RootPath+"\Site3\af_vnet_azuredeploy_template_Site3_services_A.json"

$ParametersPathVNET400=$RootPath+"\Site4\af_vnet_azuredeploy_parameters_Site4_prod_A.json"
$TemplatePathVNET400=$RootPath+"\Site4\af_vnet_azuredeploy_template_Site4_prod_A.json"
$ParametersPathVNET401=$RootPath+"\Site4\af_vnet_azuredeploy_parameters_Site4_hbi_A.json"
$TemplatePathVNET401=$RootPath+"\Site4\af_vnet_azuredeploy_template_Site4_hbi_A.json"
$ParametersPathVNET402=$RootPath+"\Site4\af_vnet_azuredeploy_parameters_Site4_preprod_A.json"
$TemplatePathVNET402=$RootPath+"\Site4\af_vnet_azuredeploy_template_Site4_preprod_A.json"
$ParametersPathVNET403 =$RootPath+"\Site4\af_vnet_azuredeploy_parameters_Site4_storage_A.json"
$TemplatePathVNET403 =$RootPath+"\Site4\af_vnet_azuredeploy_template_Site4_storage_A.json"
$ParametersPathVNET404=$RootPath+"\Site4\af_vnet_azuredeploy_parameters_Site4_services_A.json"
$TemplatePathVNET404=$RootPath+"\Site4\af_vnet_azuredeploy_template_Site4_services_A.json"

# select subscription
#Write-Host "Selecting subscription '$subscriptionId'";

# Register RPs
$resourceProviders = @("microsoft.compute","microsoft.network");
if($resourceProviders.length) {
    Write-Host "Registering resource providers"
    foreach($resourceProvider in $resourceProviders) {
        RegisterRP($resourceProvider);
    }
}


<#
*****************Services (VNET304)*******************
#>
Select-AzureRmSubscription -SubscriptionID $SubID_Services;
$servicesResourceGroup1 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet304 -ErrorAction SilentlyContinue
$servicesResourceGroup2 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet404 -ErrorAction SilentlyContinue

#Create or check for existing resource group
if(!$servicesResourceGroup1)
{
    Write-Host "Resource group '$ResourceGroupName_vnet304' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_3) {
        $locationSite_3 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet304' in location '$locationSite_3'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet304 -Location $locationSite_3
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet304'";
}
if(!$servicesResourceGroup2)
{
    Write-Host "Resource group '$ResourceGroupName_vnet404' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_4) {
        $locationSite_4 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet404' in location '$locationSite_4'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet404 -Location $locationSite_4
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet404'";
}
<#
This section is where we build the NSG for the VNET afr locatedry where json files eecto ../ and run the powershell from di
#>

# Start the deployment

Test-AzureRmResourceGroupDeployment  -ResourceGroupName $ResourceGroupName_vnet304 -TemplateFile $TemplatePathVNET304 -TemplateParameterFile $ParametersPathVNET304;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet304 -Templatefile $TemplatePathVNET304 -TemplateParameterfile $ParametersPathVNET304;


# Start the deployment

Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName_vnet404 -TemplateFile $TemplatePathVNET404 -TemplateParameterFile $ParametersPathVNET404;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet404 -Templatefile $TemplatePathVNET404 -TemplateParameterfile $ParametersPathVNET404;

<#Troubleshooting
#Debug
#$deploymentName = "AzureFoundationSite3A_Debug1b"
#New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet304 -Templatefile $TemplatePathVNET304 -TemplateParameterfile $ParametersPathVNET304 -DeploymentDebugLogLevel All;

$Operations = Get-AzureRmResourceGroupDeploymentOperation -DeploymentName $deploymentName -ResourceGroupName $ResourceGroupName_vnet404
foreach($Operation in $Operations){
Write-Host $operation.id
$Operation.properties.request | ConvertTo-Json -Depth 10
    Write-Host "Request:"
$Operation.properties.response | ConvertTo-Json -Depth 10
 Write-Host "Response:"}
 #>

<#
**************************Production Subscription***************
#>

Select-AzureRmSubscription -SubscriptionID $SubID_Prod;
$prodResourceGroup1 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet300 -ErrorAction SilentlyContinue
$prodResourceGroup2 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet400 -ErrorAction SilentlyContinue

if(!$prodResourceGroup1)
{
    Write-Host "Resource group '$ResourceGroupName_vnet300' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_3) {
        $locationSite_3 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet300' in location '$locationSite_3'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet300 -Location $locationSite_3
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet300'";
}
if(!$prodResourceGroup2)
{
    Write-Host "Resource group '$ResourceGroupName_vnet400' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_4) {
        $locationSite_4 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet400' in location '$locationSite_4'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet400 -Location $locationSite_4
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet400'";
}
<#
This section is where we build the NSG for the VNET
#>

# Start the deployment

Test-AzureRmResourceGroupDeployment  -ResourceGroupName $ResourceGroupName_vnet300 -TemplateFile $TemplatePathVNET300 -TemplateParameterFile $ParametersPathVNET300;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet300 -Templatefile $TemplatePathVNET300 -TemplateParameterfile $ParametersPathVNET300;


# Start the deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName_vnet400 -TemplateFile $TemplatePathVNET400 -TemplateParameterFile $ParametersPathVNET400;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet400 -Templatefile $TemplatePathVNET400 -TemplateParameterfile $ParametersPathVNET400;

<#
**************************PrepreProduction Subscription***************
#>

Select-AzureRmSubscription -SubscriptionID $SubID_preProd
$preProdResourceGroup1 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet302 -ErrorAction SilentlyContinue
$preProdResourceGroup2 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet402 -ErrorAction SilentlyContinue

if(!$preProdResourceGroup1)
{
    Write-Host "Resource group '$ResourceGroupName_vnet302' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_3) {
        $locationSite_3 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet302' in location '$locationSite_3'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet302 -Location $locationSite_3
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet302'";
}
if(!$preProdResourceGroup2)
{
    Write-Host "Resource group '$ResourceGroupName_vnet402' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_4) {
        $locationSite_4 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet402' in location '$locationSite_4'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet402 -Location $locationSite_4
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet402'";
}
<#
This section is where we build the NSG for the VNET
#>

# Start the deployment
Test-AzureRmResourceGroupDeployment  -ResourceGroupName $ResourceGroupName_vnet302 -TemplateFile $TemplatePathVNET302 -TemplateParameterFile $ParametersPathVNET302;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet302 -Templatefile $TemplatePathVNET302 -TemplateParameterfile $ParametersPathVNET302;

# Start the deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName_vnet402 -TemplateFile $TemplatePathVNET402 -TemplateParameterFile $ParametersPathVNET402;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet402 -Templatefile $TemplatePathVNET402 -TemplateParameterfile $ParametersPathVNET402;

<#
**************************High Business Impact Subscription***************
#>

Select-AzureRmSubscription -SubscriptionID $SubID_HBI

$hbiResourceGroup1 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet301 -ErrorAction SilentlyContinue
$hbiResourceGroup2 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet401 -ErrorAction SilentlyContinue

if(!$hbiResourceGroup1)
{
    Write-Host "Resource group '$ResourceGroupName_vnet301' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_3) {
        $locationSite_3 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet301' in location '$locationSite_3'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet301 -Location $locationSite_3
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet301'";
}
if(!$hbiResourceGroup2)
{
    Write-Host "Resource group '$ResourceGroupName_vnet401' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_4) {
        $locationSite_4 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet401' in location '$locationSite_4'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet401 -Location $locationSite_4
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet401'";
}
<#
This section is where we build the NSG for the VNET
#>

# Start the deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName_vnet301 -TemplateFile $TemplatePathVNET301 -TemplateParameterFile $ParametersPathVNET301;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet301 -Templatefile $TemplatePathVNET301 -TemplateParameterfile $ParametersPathVNET301;

# Start the deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName_vnet401 -TemplateFile $TemplatePathVNET401 -TemplateParameterFile $ParametersPathVNET401;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet401 -Templatefile $TemplatePathVNET401 -TemplateParameterfile $ParametersPathVNET401;

<#
**************************Storage Subscription***************
#>

Select-AzureRmSubscription -SubscriptionID $SubID_Storage;
$storageResourceGroup1 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet303 -ErrorAction SilentlyContinue
$storageResourceGroup2 = Get-AzureRmResourceGroup -Name $ResourceGroupName_vnet403 -ErrorAction SilentlyContinue

if(!$storageResourceGroup1)
{
    Write-Host "Resource group '$ResourceGroupName_vnet303' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_3) {
        $locationSite_3 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet303' in location '$locationSite_3'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet303 -Location $locationSite_3
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet303'";
}
if(!$storageResourceGroup2)
{
    Write-Host "Resource group '$ResourceGroupName_vnet403' does not exist. To create a new resource group, please enter a location.";
    if(!$locationSite_4) {
        $locationSite_4 = Read-Host "resourceGroupLocation";
    }
    Write-Host "Creating resource group '$ResourceGroupName_vnet403' in location '$locationSite_4'";
    New-AzureRmResourceGroup -Name $ResourceGroupName_vnet403 -Location $locationSite_4
}
else{
    Write-Host "Using existing resource group '$ResourceGroupName_vnet403'";
}

# Start the deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName_vnet303 -TemplateFile $TemplatePathVNET303 -TemplateParameterFile $ParametersPathVNET303;

# Start the deployment
Test-AzureRmResourceGroupDeployment -ResourceGroupName $ResourceGroupName_vnet403 -TemplateFile $TemplatePathVNET403 -TemplateParameterFile $ParametersPathVNET403;
New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet303 -Templatefile $TemplatePathVNET303 -TemplateParameterfile $ParametersPathVNET303;

New-AzureRmResourceGroupDeployment -name $deploymentName -ResourceGroupName $ResourceGroupName_vnet403 -Templatefile $TemplatePathVNET403 -TemplateParameterfile $ParametersPathVNET403;

