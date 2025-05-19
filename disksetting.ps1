#!/usr/bin/pwsh

Clear-Host
Write-Host "`nWelcome! Disk configuration begins..." -ForegroundColor Cyan

# Status query
Get-Disk
Get-PhysicalDisk
Get-Partition
Get-Volume
Write-Host ""

# Disk initialization
$initNumber = Read-Host "Which disk number would you like to initialize? (e.g. 1)"
$partitionStyle = Read-Host "Which partition style? (GPT / MBR)"
Initialize-Disk -Number $initNumber -PartitionStyle $partitionStyle -Confirm:$false
Write-Host "Disk #$initNumber initialized with $partitionStyle." -ForegroundColor Green

# Create a partition
$diskNumber = Read-Host "Which disk number to partition? (e.g. 1)"
$size = Read-Host "How many GBs do you want to reserve? (leave blank for full size)"
$letter = Read-Host "What drive letter should it have? (e.g. H, leave blank for random)"

if ([string]::IsNullOrWhiteSpace($size)) {
    # Entire disk
    if ([string]::IsNullOrWhiteSpace($letter)) {
        $partition = New-Partition -DiskNumber $diskNumber -UseMaximumSize -AssignDriveLetter
    } else {
        $partition = New-Partition -DiskNumber $diskNumber -UseMaximumSize -DriveLetter $letter
    }
} else {
    $sizeBytes = [int64]$size * 1GB
    if ([string]::IsNullOrWhiteSpace($letter)) {
        $partition = New-Partition -DiskNumber $diskNumber -Size $sizeBytes -AssignDriveLetter
    } else {
        $partition = New-Partition -DiskNumber $diskNumber -Size $sizeBytes -DriveLetter $letter
    }
}

$actualLetter = $partition.DriveLetter
Write-Host "Partition created on disk #$diskNumber with drive letter $actualLetter." -ForegroundColor Green

# Formatting
$FileSystem = Read-Host "Which file system? (e.g. NTFS, exFAT)"
$label = Read-Host "Enter volume label (optional)"

if ([string]::IsNullOrWhiteSpace($label)) {
    Format-Volume -DriveLetter $actualLetter -FileSystem $FileSystem -Confirm:$false
} else {
    Format-Volume -DriveLetter $actualLetter -FileSystem $FileSystem -NewFileSystemLabel $label -Confirm:$false
}

Write-Host "`nDisk successfully configured and formatted!" -ForegroundColor Cyan
