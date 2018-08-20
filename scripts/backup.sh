#!/bin/bash
docker exec climbingexpeditions_postgres_1 pg_dumpall -U postgres -c -s --verbose > ../database/backupAll2.sql