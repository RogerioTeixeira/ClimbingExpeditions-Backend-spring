#!/bin/bash
RISPOSTA=$(docker-machine status)
if [ ${RISPOSTA} = "Stopped" ] 
then 
  docker-machine start
fi  
docker exec -i climbingexpeditions_postgres_1 pg_dumpall -U postgres -c -s --verbose > ../database/backupAll2.sql