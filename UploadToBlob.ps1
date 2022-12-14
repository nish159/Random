<#
    Note that this function uses the Azure PowerShell cmdlets to interact with Azure Storage. 
    In order to use these cmdlets, you will need to install the Azure PowerShell module and 
    authenticate to your Azure account.

function UploadFileToBlob {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [System.Net.Http.HttpRequestMessage]$Request,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSObject]$TriggerMetadata,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSObject]$BindingData,

        [Parameter(Mandatory=$true)]
        [System.Management.Automation.PSObject]$Log
    )

    try {
        # Get the file from the request body
        $file = $Request.Content.ReadAsMultipartAsync().Result.Contents[0]

        # Read the file content
        $fileContent = $file.ReadAsByteArrayAsync().Result

        # Connect to Azure Storage
        $connectionString = $env:StorageConnectionString
        $blobServiceClient = New-AzureStorageBlobClient -ConnectionString $connectionString

        # Get a reference to the container
        $containerName = "file-upload"
        $containerClient = $blobServiceClient.GetContainerReference($containerName)

        # Create the container if it doesn't exist
        if (-not ($containerClient.Exists())) {
            $containerClient.Create()
        }

        # Get a reference to the blob
        $fileName = $file.Headers.ContentDisposition.FileName
        $blobClient = $containerClient.GetBlockBlobReference($fileName)

        # Upload the file to the blob
        $blobClient.UploadFromByteArrayAsync($fileContent, 0, $fileContent.Length).Wait()

        # Return success message
        return [System.Web.Http.Results.OkObjectResult]::new("File $fileName uploaded to container $containerName")
    }
    catch {
        $errorMessage = $_.Exception.Message
        $Log.Error($errorMessage)
        return [System.Web.Http.Results.BadRequestObjectResult]::new("Error uploading file to blob storage: $errorMessage")
    }
}
#>

$storageAccountName = "mystorageaccount"
$storageAccountKey = "storageaccountkey"
$containerName = "mycontainer"

# Connect to the storage account
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Set the path to the file you want to upload
$filePath = "C:\path\to\myfile.txt"

# Set the name that the file will have in the blob container
$blobName = "myblob.txt"

# Upload the file to the container
Set-AzureStorageBlobContent -File $filePath -Container $containerName -Blob $blobName -Context $storageContext

