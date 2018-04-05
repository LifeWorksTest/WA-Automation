#!/bin/sh
source /srv/environment

cd "$(dirname "$0")"

if [ "$APPLICATION_ENV" = "production" ]; then
    echo "This DB drop can\'t be run on $APPLICATION_ENV environment"
    exit
fi

DB_WAM_CONN=''
if [[ -n  $DB_WAM_USER  ]]; then
    DB_WAM_CONN="-u $DB_WAM_USER -p $DB_WAM_PASSWORD"
fi

DB_ARCH_CONN=''
if [[ -n  $DB_ARCH_USER  ]]; then
    DB_ARCH_CONN="-u $DB_ARCH_USER -p $DB_ARCH_PASSWORD"
fi

# Dump the current WAM and Arch DB
echo "Dump WAM DB"
mongodump --host "$DB_WAM_HOST" -d "$DB_WAM_DBNAME" $DB_WAM_CONN
echo "Dump Arch DB"
mongodump --host "$DB_ARCH_HOST" -d "$DB_ARCH_DBNAME" $DB_ARCH_CONN

# Create new Arch DB
echo "Create Arch DB"
mongo  --host "$DB_ARCH_SHELL_CONNECTION_STRING" $DB_ARCH_CONN db/arch.js