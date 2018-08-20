#!/bin/bash
#!export PGPASSWORD="xrte1982"
#!docker exec -i -e PGPASSWORD=xrte1982 climbingexpeditions_postgres_1 pg_restore --host "postgres" --port "5432" --username "postgres" --dbname "climb" --clean --verbose < ../database/backup.dump

RISPOSTA=$(docker-machine status)
if [ ${RISPOSTA} = "Stopped" ] 
then 
  docker-machine start
fi
echo "inizio restore"
docker exec -i climbingexpeditions_postgres_1 psql --username "postgres"  -a < ../database/backupall2.sql 
