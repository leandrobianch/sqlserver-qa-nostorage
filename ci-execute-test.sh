#!/bin/bash
#import  scripts for using log
. ./build/initial_database.sh 

# Stop required services
docker-compose -f docker-compose.yml down
log "Compose Services DOWN"

CONTAINER_NAME=SqlServerQANoStorage

docker-compose -f docker-compose.yml up -d  
log "Compose Services UP"

CONTAINER_HEALTH=$(docker inspect --format='{{json .State.Health.Status}}' $CONTAINER_NAME)
if [ -z $CONTAINER_HEALTH ]; then
    log "Container not found status: $CONTAINER_HEALTH"
    exit 0
fi;

# waiting until container started and status healthy
until test $CONTAINER_HEALTH = "\"healthy\""; do
    log "Status: $CONTAINER_HEALTH"
    sleep 1
    CONTAINER_HEALTH=$(docker inspect --format='{{json .State.Health.Status}}' $CONTAINER_NAME)
    if [ -z $CONTAINER_HEALTH ]; then
        log "Container crashed status: $CONTAINER_HEALTH"
        exit 1
    fi;
done

log "Ready status: $CONTAINER_HEALTH"

# connect and execute initial database 
docker exec -d $CONTAINER_NAME /bin/bash initial_database.sh init

log "Initial database executed !"
