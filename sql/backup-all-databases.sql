-- Create a backup of all databases in a MSSQL hosted in Docker

DECLARE @DatabaseName NVARCHAR(255)
DECLARE DatabaseCursor CURSOR FOR
    SELECT name
    FROM sys.databases
    WHERE database_id > 4  -- Exclude system databases

OPEN DatabaseCursor
FETCH NEXT FROM DatabaseCursor INTO @DatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @BackupPath NVARCHAR(255)
    SET @BackupPath = '/var/opt/mssql/data/' + @DatabaseName + '_Backup.bak'

    -- Use the BACKUP command to take a full database backup
    DECLARE @BackupCommand NVARCHAR(MAX)
    SET @BackupCommand = 'BACKUP DATABASE [' + @DatabaseName + '] TO DISK = N''' + @BackupPath + ''' WITH FORMAT, INIT, STATS=10'

    -- Execute the backup command
    EXEC sp_executesql @BackupCommand

    FETCH NEXT FROM DatabaseCursor INTO @DatabaseName
END

CLOSE DatabaseCursor
DEALLOCATE DatabaseCursor
