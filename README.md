##
sh build.sh && sh run.sh 
SqlServerQANoStorage# sqlserver-qa-nostorage

DATABASE_NAME=test_db_2 \
USERNAME_APPLICATION=application_user \
PASSWORD_APPLICATION=Pass_word_123 \
SA_PASSWORD=Admin@123 \
docker-compose -f docker-compose.yml up --no-cache


docker-compose build . -f docker-compose.yml \
-e 'ACCEPT_EULA=Y' \
-e 'SA_PASSWORD=Admin@123' \
-e DATABASE_NAME=test_db \
-e USERNAME_APPLICATION=application_user \
-e PASSWORD_APPLICATION=Pass_word_123 


docker-compose -f docker-compose.yml \
-e 'ACCEPT_EULA=Y' \
-e 'SA_PASSWORD=Admin@123' \
-e DATABASE_NAME=test_db \
-e USERNAME_APPLICATION=application_user \
-e PASSWORD_APPLICATION=Pass_word_123 

docker-compose -f docker-compose.yml up -d \
-e 'ACCEPT_EULA=Y' \
-e 'SA_PASSWORD=Admin@123' \
-e DATABASE_NAME=test_db \
-e USERNAME_APPLICATION=application_user \
-e PASSWORD_APPLICATION=Pass_word_123 
