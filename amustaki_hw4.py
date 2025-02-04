#!/usr/bin/env python3

import cgi
import cgitb
import pymysql
import json


#return errors to browser
cgitb.enable()
#start http return
print("Content-type: text/html\n")

# retrieve form data, if any
form = cgi.FieldStorage()
#check if form data is returned

if form:
#Connect to the database.
	connection = pymysql.connect(db='miRNA',user='amustaki',password='amust$

    cursor = connection.cursor()
    selector = form.getvalue("selector","")
    miRNA_sequence = form.getvalue("miRNA_sequence","")
    miRNA = form.getvalue("miRNA","")

    if (selector == "mi_gene"):
            query = """
            SELECT score
            FROM miRNA join targets using(mid)
            WHERE name regexp %s"""

            cursor.execute(query,(miRNA))
            results=cursor.fetchall()
            print(json.dumps(results))

    elif (selector=="miRNA_seq"):
   #specify the query for the interacting proteins
            query = """
            SELECT name, seq
            FROM miRNA
            WHERE seq regexp %s"""

            cursor.execute(query,(miRNA_sequence))
            results=cursor.fetchall()
            print(json.dumps(results))
    else:
             print('none')