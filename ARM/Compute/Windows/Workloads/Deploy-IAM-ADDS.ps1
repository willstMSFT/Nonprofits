[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False)]
  [string]$SubscriptionName = "MAC_SLG_Managed_Services",
	
  [Parameter(Mandatory=$False)]
  [string]$SubscriptionId,

  [Parameter(Mandatory=$False)]
  [PSCredential]$Credential = $null
)

$ErrorActionPreference = "Stop"

if ($credential) {
    #Using passed credential object
}
else {
    #Prompt for Azure AD credentials
    $Credential = Get-Credential -Message "Please enter your credentials to authenticate to Azure AD"
}

try {
    #ARM Login for US GovCloud
    #$envARM = Get-AzureRmEnvironment AzureUSGovernment

    #ARM Login for Azure commercial cloud
    $envARM = Get-AzureRmEnvironment AzureCloud

    Login-AzureRmAccount -Credential $Credential -EnvironmentName $envARM
}
catch {
    "Error logging in to Azure AD with supplied credentials"
}

#Select-AzureSubscription -SubscriptionName $SubscriptionName -Default

.\Deploy-AzureResourceGroup.ps1 -ResourceGroupName "rg_ADDS" -ResourceGroupLocation "westcentralus" -ArtifactStagingDirectory "IAM-ADDS" -UploadArtifacts -StorageAccountName "stage9a3c609411534deaa72" -StorageContainerName "iam-adds-stageartifacts"
