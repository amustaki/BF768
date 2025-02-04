#!/usr/bin/env python3

#import all the libraries needed 
import cgi 
import cgitb
cgitb.enable(logdir = "/var/www/cgi-bin/students_22/amustaki" ) 
from string import Template
import pymysql

#use the execute query from the last homework in order to be able to run the query 
#change the database to be miRNA 
def execute_query(dtbs,usrnm,pswd,gene1,gene2):
  # connect to the database
    connection = pymysql.connect(host='bioed.bu.edu',user=usrnm,password=pswd,db=dtbs,port = 4253,local_infile=1,autocommit = True)
        # get cursor
    cursor = connection.cursor()
    query="""select miRNA.name as "miRNA Name", t1.score as "Gene 1 Score", t2.score as "Gene 2 Score" from miRNA join targets t1 using(mid) join gene g1 on g1.gid=t1.gid join targets t2 using (mid) join gene g2 on g2.gid=t2.gid where g1.name = %s and g2.name = %s;"""
  # run query
    try:
        cursor.execute(query, [gene1,gene2])
    except pymysql.Error as e:
        print(e)
  # fetch results
    results = cursor.fetchall()
  # close the connection
    cursor.close()
    connection.close()
        # return the results
    return results



form_template = Template(
"""
<html>
    <head> 
        <title> miRNA Comparison</title> 
    <body>  
        <form name="myForm" action="https://bioed.bu.edu/cgi-bin/students_22/amustaki/athenamustakis_doubleSearch.py" method="get">
	    <h3>Homework Assignment 4</h3>
	    <h2>miRNA Comparison Finding the Target Genes</h2>
            <p> 
            User inputs two genes into the textboxes and the website will return the shared targets and target scores<br> 
            Gene One: <input type="text" name="gene1"><br>
            Gene Two: <input type="text" name="gene2"><br>
            ex. Gene 1 = A1CF and Gene 2 = AFF4<br> 
            </p>
            <input type="submit" value="Submit">
            </form>
    </body>
</html> 
"""
)

form = cgi.FieldStorage(keep_blank_values=True) 
print("Content-type: text/html\n")
#if else statements for how the values are entered, what happens if they form is submitted blank, just one gene is entered, or that there are no matches which is where the length of the results would be 0 and then if the form was filled out correctly 
if(form):
    gene1 = form.getvalue("gene1", "")
    gene2 = form.getvalue("gene2", "")
    if gene1 != "" and gene2 != "":
#if the two genes from the sheet are not equal to blank values then let the query be executed 
        results = execute_query('miRNA', 'amustaki', 'amustaki', gene1, gene2)
        if len(results) > 0: 
            result_template = """
            <html>
                <head>
                </head>
                <body>
                    <p>
                    Gene %s and gene %s are both targeted by %s miRNAs<br>
                    </p>
                    <table>
                        <thead>
                            <tr>
                                <th>miRNA Name</th>
                                <th>Gene1 Target Score</th>
                                <th>Gene2 Target Score</th>
                            </tr>
                        </thead>
                        <tbody> 
            """ %(gene1, gene2, str(len(results)))   
            for row in results:
                result_template += """
                    <tr>
                        <td>%s</td> 
                        <td>%s</td>
                        <td>%s</td>
                    </tr>
                """ %(row[0], row[1], row[2])
            result_template += """
                        <tbody>
                    </table>
                </body>
            </html>
            """
            print(form_template.safe_substitute())
            print(result_template)
        else:
#for when the genes entered have no matches, which would mean that the length of the result is 0  
            nomatch = """
            <html>
                <head> 
                    <title> Homework 4 </title> 
                <body>  
                    <form name="myForm" action="https://bioed.bu.edu/cgi-bin/students_22/amustaki/athenamustakis_doubleSearch.py" method="get">
                        <h3> Homework 4 </h3>
			<h2> miRNA Comparison Finding the Target Genes </h2>
			<p> 
                        User inputs two genes into the textboxes and the website will return the shared targets and target scores for each gene<br> 
                        Gene One: <input type="text" name="gene1"><br>
                        Gene Two: <input type="text" name="gene2"><br>
                        ex. Gene 1 = A1CF and  Gene 2 = AFF4<br> 
                        </p>
                        <input type="submit" value="Submit">
                    </form>
                    <p>
                    No matching miRNAs targets found for these two genes<br>
                    </p>
                </body>
            </html> 
            """
            print(nomatch)
    else: 
#for when there is empty fields
        empty = """
        <html> 
            <head> 
                <title> Homework 4 </title> 
            <body> 
                <form name ="myForm" action="https://bioed.bu.edu/cgi-bin/students_22/amustaki/athenamustakis_doubleSearch.py" method="get">
                    <h3> Homework Assignment 4 </h3>
		    <h2> miRNA Comparison Finding the Target Genes </h2>
		    <p>
                    User inputs two genes into the textboxes and the website will return the shared targets and target scores for each gene<br> 
                    Gene One: <input type="text" name="gene1"><br>
                    Gene Two: <input type="text" name="gene2"><br>
                    ex. Gene 1 = A1CF and Gene 2 = AFF4<br> 
                    </p>
                    <input type = "submit" value = "Submit">
                </form> 
                <p>
                No gene names entered/one of the fields is empty<br>
                </p>
            </body> 
        </html>
        """
        print(empty)
else:
    print(form_template.safe_substitute())


