#!/bin/bash

dumpname="sixminutestory.dump"

app="sm6"
read -e -p "Please enter your Heroku app name [$app]: " input_app
app="${input_app:-$app}"

username="postgres"
read -e -p "Please enter your postgres username [$username]: " input_username
username="${input_username:-$username}"

database="sm6_development"
read -e -p "Please enter your postgres database [$database]: " input_database
database="${input_database:-$database}"

heroku pg:backups capture -a $app

curl -o $dumpname `heroku pg:backups public-url -a $app`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $username -d $database $dumpname

delete_dump="y"
echo "####################"
echo "If there were errors and you want to try again, enter 'no' on the prompt below and then run"
echo "$ pg_restore --verbose --clean --no-acl --no-owner -h localhost -U <USERNAME> -d <DATABASE> <DUMPNAME>"

read -e -p "Do you want to delete the dump file? ($dumpname) [$delete_dump]" input_delete_dump
delete_dump="${input_delete_dump:-$delete_dump}"

if [ $delete_dump == 'y' ]
	then
		rm $dumpname
fi
