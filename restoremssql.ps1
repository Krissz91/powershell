Clear-Host

Write-Host "Welcome back, $env:USERNAME!"
Write-Host "This is an interactive MSSQL database restore script in PowerShell"

# Input
$databaseName = Read-Host "Please enter the name of the database to restore"
$serverName = Read-Host "Enter the name of the MSSQL server (e.g. localhost or 'IP address')"
$backupFile = Read-Host "Enter the full path to the .bak file (e.g. C:\Backups\MyDB_backup.bak)"

# Validate path
if (Test-Path $backupFile) {Write-Host "We found the backup file at the specified path..." -ForegroundColor Green -BackgroundColor Black}
else {Write-Host "Backup file not found at the specified path." -ForegroundColor Red -BackgroundColor Black
        exit 1}

# Overwrite?
$overwrite = Read-Host "Do you want to overwrite the existing database if it exists? (Y/N)"
$replaceOption = ""
if ($overwrite -eq "Y" -or $overwrite -eq "y") {
    $replaceOption = "REPLACE,"
}

# --- Step 1: Get logical file names ---
$restoreFileList = Invoke-Sqlcmd -ServerInstance $serverName -Query "RESTORE FILELISTONLY FROM DISK = N'$backupFile'"
$logicalData = ($restoreFileList | Where-Object { $_.Type -eq 'D' }).LogicalName
$logicalLog = ($restoreFileList | Where-Object { $_.Type -eq 'L' }).LogicalName

# --- Step 2: Define destination paths (customize this as needed!) ---
$dataDir = "C:\SQLData"

if (Test-Path $dataDir) {Write-Host "We found the data directory..." -ForegroundColor Yellow -BackgroundColor Black}
else {Write-Host "We don't found the directory, but we are creating data directory at $dataDir..." -ForegroundColor Red -BackgroundColor Black
      New-Item -ItemType Directory -Path $dataDir | Out-Null}

$dataPath = "$dataDir\$databaseName.mdf"
$logPath  = "$dataDir\$databaseName.ldf"

# --- Step 3: Build the restore SQL ---
$restoreCommand = @"
RESTORE DATABASE [$databaseName]
FROM DISK = N'$backupFile'
WITH FILE = 1,
MOVE N'$logicalData' TO N'$dataPath',
MOVE N'$logicalLog' TO N'$logPath',
$replaceOption
NOUNLOAD, STATS = 5
"@

# --- Step 4: Execute ---
Write-Host "Starting restore process..."
Invoke-Sqlcmd -ServerInstance $serverName -Query $restoreCommand

Write-Host "Restore command has been issued. Please check SQL Server for confirmation." -ForegroundColor Green -BackgroundColor Black
