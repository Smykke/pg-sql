#!/bin/bash

# Basic setup
#host=localhost
#port=3306
user=postgres
#password=
database=localsqltest

# How to read a file into a variable in shell?
# https://stackoverflow.com/questions/7427262/how-to-read-a-file-into-a-variable-in-shell
key=$(<in_professor.sql)
script=$(<in_student.sql)
# $key = Get-Content < in_professor.sql
# $script = Get-Content < in_student.sql
# $key
# $script
echo "$key"
echo "$script"

# How to fetch field from MySQL query result in bash
# https://stackoverflow.com/questions/9558867/how-to-fetch-field-from-mysql-query-result-in-bash
psql -U $user -d $database -f "select verifySQLQuery('$key', '$script');" > result.txt
resut=$(<result.txt)
echo "$result"

if [ $result -eq 'True' ]; then
	echo "Correto"
else
	echo "Incorreto"
fi
