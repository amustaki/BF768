#!/usr/bin/python
import pymysql
import sys

# START FUNCTION DEFINITIONS
def read_query(filename):
	# open the file
	file = open(filename, "rt")
	line = file.readline()
	# initialize a variable (to store the query) as empty string
	inputstr <- ""
	
	# concatenate each line (remove \n) to the sequence
	
	while line:
		newlinegone = line.strip('/n')
		inputstr = newlinegone + inputstr
	
	# close the file
	
	file.close()
	# return the sequence
	return inputstr 
	
def execute_query(dtbs,usrnm,pswd,query):
	# connect to the database
	connection = pymysql.connect(
	host = 'bioed.bu.edu',
	user = usrnm,
	password = pswd,
	db = dtbs,
	port = 4253)
		
	# get cursor
	cursor = connection.cursor()
	
	# run query
	try: 
		cursor.execute(query)
	except pymysql.Error as e: 
		print(e)
	
	connection.commit()  #committing the changes 
	# fetch results 

	results = cursor.fecthall()
	print(result)
	# close the connection

	connection.close()
	# return the results
	return results 

# FUNCTIONS FINISHED


# THIS IS THE MAIN BODY OF CODE THAT WILL CALL THE FUNCTIONS:

# get arguments from system argument list
dtbs = sys.argv[1]
usr  = sys.argv[2]
pswd = sys.argv[3]
filename = sys.argv[4]

# parse the query file using function read_query
query = read_query('query1.sql')

# execute the query and get the results
results = execute_query(dtbs,usrnm,pswd,query)

# print the results, one row at a time
for row in results: 
	print(row)