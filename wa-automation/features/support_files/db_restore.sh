#!/bin/sh

cd "$(dirname "$0")"
echo "$(dirname "$0")"
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

# Delete WAM and Arch DB
echo "Delete WAM DB"
mongo $DB_WAM_DBNAME dump/$DB_WAM_DBNAME --eval "db.dropDatabase()"

echo "Delete Arch DB"
mongo $DB_WAM_DBNAME dump/$DB_ARCH_DBNAME --eval "db.dropDatabase()"


# Restore old WAM and Arch DB
echo "Restore WAM DB"
#mongorestore --nsInclude $DB_WAM_DBNAME dump/$DB_WAM_DBNAME
mongorestore -d $DB_WAM_DBNAME dump/$DB_WAM_DBNAME
echo "Restore WAM DB"
#mongorestore --nsInclude $DB_WAM_DBNAME dump/$DB_ARCH_DBNAME
mongorestore -d $DB_WAM_DBNAME dump/$DB_ARCH_DBNAME

# Remove dump folder
#rm -r "dump"