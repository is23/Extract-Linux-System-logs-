#!/bin/bash


#for taking everything from the syslog file and  to put in text file
grep ".*" /var/log/syslog | while read x;do y=`expr "$x" : "\(.*\)"`; echo "${y}" >> saveLog.txt; done

#put each field in seperate text file by using grep
#for severity level
grep "[0-9],[0-9],.*" saveLog.txt | while read x;do y=`expr "$x" : "\(.*\),.*,.*,.*,.*,"`; echo "${y}" >> severity.txt; done


#for date and time
grep "[0-9],[0-9],.*" saveLog.txt | while read x;do y=`expr "$x" : ".*,.*,\(.*\),.*,.*,"`; echo "${y}" >> time.txt; done


#for tag name
grep "[0-9],[0-9],.*" saveLog.txt | while read x;do y=`expr "$x" : ".*,.*,.*,.*,\(.*\),"`; echo "${y}" >> tag.txt; done


#for message description
grep "[0-9],[0-9],.*" saveLog.txt | while read x;do y=`expr "$x" : ".*,.*,.*,.*,.*,\(.*\)"`; echo "${y}" >> description.txt; done


#paste the txt files into a .csv file to later append in mysql table
paste -d, severity.txt time.txt tag.txt description.txt  >temptable.csv


#mysql queries to make table in database (db for me) for logging
#-p for mysql password need to be provided
mysql -u root -p << EOF 
use db;
create table logs(Severity varchar(1), Time varchar(20), Tag varchar(50), Description varchar(255));
EOF


#looping through "," sperated file and start inserting data to table logs
IFS=','
while read se ti ta de; do  #each variable for each coulmn
    echo "insert into logs (Severity, Time, Tag, Description) values ('$se', '$ti', '$ta', '$de');"
done < temptable.csv |mysql -u root -p db #db database name
