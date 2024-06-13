Import-Module AWS.Tools.S3

$region = "us-east-1"

$bucketName = Read-Host Prompt "Enter the S3 bucket name"

Write-Host "AWS Region: $region"
Write-Host "S3 Bucket: $bucket Name"

New-S3Bucket BucketName $bucketName Region $region

# Create a new file
