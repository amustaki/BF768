#!/usr/bin/env python3
import pymysql 

connection = pymysql.connect(
host = 'bioed.bu.edu',
user = 'amustaki',
password = 'amustaki',
db = 'amustaki',
port = 4253,
local_infile = 1)

#create the cursor object 
cursor = connection.cursor()

#drop table command for pathways before the create table statement 
cursor.execute("DROP TABLE IF EXISTS Pathways")

#create the table pathways 
pathway = '''CREATE TABLE Pathways(
path_id INTEGER NOT NULL ,
pathname VARCHAR(100),
PRIMARY KEY(path_id)
)'''

cursor.execute(pathway)

load_data = '''LOAD DATA LOCAL INFILE 'pathways(3).tab' INTO TABLE Pathways FIELDS TERMINATED BY '/t'; '''

cursor.execute(load_data)

connection.commit()
cursor.close()
connection.close()