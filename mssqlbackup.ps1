Clear-Host
# Author: Krisztian Toth
# Created: 05/06/2025
# Description: MSSQL Database Backup Script in PowerShell

Write-Host "Greetings, $env:USERNAME!"
Write-Host "This is an interactive MSSQL database backup script in PowerShell: "

# Request MSSQL Database Name
$databaseName = Read-Host "Please enter the database name: "

# Request server information
$serverName = Read-Host "Enter the name of the MSSQL server (e.g. localhost or 'IP address'): "

# Specifying a backup destination directory
$destinationDir = Read-Host "Specify the destination directory for the save: "
if (-not (Test-Path $destinationDir)) {
    New-Item -ItemType Directory -Path $destinationDir | Out-Null
}

# Save file name and timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = Join-Path $destinationDir "${databaseName}_backup_$timestamp.bak"

# Running MSSQL Backup command
$backupCommand = "BACKUP DATABASE [$databaseName] TO DISK = N'$backupFile' WITH NOFORMAT, NOINIT, NAME = N'$databaseName-Full Database Backup', SKIP, NOREWIND, NOUNLOAD, STATS = 10"
Invoke-Sqlcmd -ServerInstance $serverName -Query $backupCommand

# Backup verification
if (Test-Path $backupFile) {
    Write-Host "Saving successfully completed! File path: $backupFile" -ForegroundColor Green
} else {
    Write-Host "An error occurred during the save." -ForegroundColor Red
}

# Stores the SQL command ($backupCommand) in a variable, which is later executed by the Invoke-Sqlcmd command.
# The parts of the backup SQL command have the following meaning:
# BACKUP DATABASE [$DATABASE_NAME] 		-> Back up the database.
# TO DISK = N'$BACKUP_FILE' 			-> Backup location (C:\Backup\something.bak).
# WITH NOFORMAT, NOINIT 			-> Does not reformat the backup file, but appends the new backup.
# NAME = N'$DATABASE_NAME-Full Database Backup' -> Name of the backup process.
# SKIP, NOREWIND, NOUNLOAD 			-> Ensures that the backup is created directly without reverting to a previous state.
# STATS = 10 					-> Displays the backup status every 10% during the process.

# Open SSMS and connect to your SQL server.
# In the Object Explorer on the left, right-click the Databases section and select Restore Database….
# In the new window, select Device and click Browse….
# Navigate to the saved .bak file (e.g. C:\Backup\something_backup_2025-06-05.bak).
# Click OK and start the restore.

# GUI (Graphical User Interface – SSMS)
# If you want to manage the backup visually, SQL Server Management Studio (SSMS) is the easiest way:
# 1. Open SSMS and connect to the MSSQL server.
# 2. In the Object Explorer pane on the left, expand the databases, then right-click on the database you want to backup.
# 3. Select Tasks -> Backup....
# 4. In the new window: Backup type: Select Full backup. Destination: Click Add and select the backup path (e.g. C:\Backup\something.bak).
# 5. Click OK and the backup will start.
# Pros: Easy to manage, no commands required. Cons: Manual setup every time.
