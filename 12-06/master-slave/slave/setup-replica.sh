#!/bin/bash

PGPASSWORD=$REPLICATION_PASSWORD pg_basebackup -h $MASTER_HOST -U $REPLICATION_USER -p 5432 -D $PGDATA -Fp -Xs -P -R -S slave1 -C
touch $PGDATA/standby.signal
exec /usr/local/bin/docker-entrypoint.sh "$@"