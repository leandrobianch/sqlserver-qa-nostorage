 CONTAINER_NAME=SqlServerQANoStorage
 docker rm -f $CONTAINER_NAME
 docker run  \
 -e 'ACCEPT_EULA=Y' \
 -e 'SA_PASSWORD=Admin@123' \
 -e DATABASE_NAME=test_db \
 -e USERNAME_APPLICATION=application_user \
 -e PASSWORD_APPLICATION=Pass_word_123 \
 --name $CONTAINER_NAME \
 -p 1433:1433 \
 -d leandrobianch/sqlserver-qanostorage:0.0.1 
 docker exec -i -t $CONTAINER_NAME /bin/bash


