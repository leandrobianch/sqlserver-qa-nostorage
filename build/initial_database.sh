#!/bin/bash
HOST_NAME_SQL_SERVER=localhost
DEFAULT_SCHEMA=dbo
TIMEOUT_UP_SQL_SERVER=15
ENABLED_LOG_DOCKER=1

function log() {
    
    patterLog="$(date +'%y-%m-%d-%H:%M:%S') dockerfile - $1"

    echo $patterLog
    
    fileLogSqlServer="/var/opt/mssql/log/errorlog";
    
    if [ $ENABLED_LOG_DOCKER -eq 1 ] && [ -f $fileLogSqlServer ]
    then
        echo $patterLog >> $fileLogSqlServer
    fi
}

function sqlReadyTimeout() {       
    
     log "Starting waiting sqlReadyTimeout up in: $TIMEOUT_UP_SQL_SERVER..."
    
     sleep $TIMEOUT_UP_SQL_SERVER
    
     log "Finish waiting sqlReadyTimeout up in: $TIMEOUT_UP_SQL_SERVER..."
}

function executeCommandSqlServer() {
    
    log "executeCommandSqlServer..."  
    
    sql=$1

    log "sqlcmd -S $HOST_NAME_SQL_SERVER -U sa -P $SA_PASSWORD -q '$sql'"

    sqlcmd -S $HOST_NAME_SQL_SERVER -U sa -P $SA_PASSWORD -q "$sql"
}

function executeCommandScriptInlineSqlServer() {
    
    log "executeCommandScriptInlineSqlServer..."  
    
    sqlFile=$1

    log "sqlcmd -S $HOST_NAME_SQL_SERVER -U sa -P $SA_PASSWORD -d $DATABASE_NAME -i '$sqlFile'"

    sqlcmd -S $HOST_NAME_SQL_SERVER -U sa -P $SA_PASSWORD -d $DATABASE_NAME -i "$sqlFile"
}

function executeScriptsInitialData() {                 
 
   log "executing executeScriptsInitialData..."              
 
    for sqlScript in "scripts/*.sql"
    do
        executeCommandScriptInlineSqlServer $sqlScript
    done

    log "executed executeScriptsInitialData..."              
}

function init(){
    sqlReadyTimeout;

    log "executing init"         

    executeCommandSqlServer "CREATE DATABASE $DATABASE_NAME"   
    
    executeCommandSqlServer "USE $DATABASE_NAME;CREATE LOGIN $USERNAME_APPLICATION WITH PASSWORD='$PASSWORD_APPLICATION',DEFAULT_DATABASE=$DATABASE_NAME;CREATE USER $USERNAME_APPLICATION FOR LOGIN $USERNAME_APPLICATION;EXEC sp_addrolemember N'db_datareader',N'$USERNAME_APPLICATION';EXEC sp_addrolemember N'db_datawriter',N'$USERNAME_APPLICATION'"

    executeScriptsInitialData

    log "executed init"    
}

init;



