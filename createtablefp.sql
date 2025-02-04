create table Gene(
	gid INT NOT NULL AUTO_INCREMENT,
	gene_names VARCHAR(40),
	ensemble_ids VARCHAR(45),
	PRIMARY KEY(gid)
) engine = innodb;

create table TempGene(
	gid INT NOT NULL AUTO_INCREMENT,
	gene_names VARCHAR(40),
	ensemble_ids VARCHAR(45),
	PRIMARY KEY(gid)
) engine = innodb;










create table Experiment(
	eid INT NOT NULL AUTO_INCREMENT,
	expcondition VARCHAR(100),
	title VARCHAR(100), 
	liu_lab BOOLEAN, 
	PRIMARY KEY(eid)
) engine = innodb;

INSERT INTO Experiment (expcondition, title, liu_lab)
VALUES ('Ischemic Stroke', 'Decoding the Transcriptional Response to Ischemic Stroke in Young and Aged Mouse Brain', FALSE),
('Healthy vs Aging', '2022 Processed Data', TRUE);

create table Expression(
	expid INT NOT NULL AUTO_INCREMENT,
	gid INT,
	eid INT,
	pvalue1 FLOAT,
	pvalue2 FLOAT,
	pvalue3 FLOAT,
	pvalue4 FLOAT,
	pvalue5 FLOAT,
	pvalue6 FLOAT,
	pvalue7 FLOAT,
	log2FC1 FLOAT,
	log2FC2 FLOAT,
	log2FC3 FLOAT,
	log2FC4 FLOAT,
	log2FC5 FLOAT,
	log2FC6 FLOAT,
	log2FC7 FLOAT,
	PRIMARY KEY(expid),
	FOREIGN KEY (gid) REFERENCES Gene(gid),
	FOREIGN KEY (eid) REFERENCES Experiment(eid)	
) engine = innodb;

LOAD DATA LOCAL INFILE 'path' INTO TABLE Expression FIELDS TERMINATED BY ',' IGNORE 1 LINES ()

create table temptable(
	gene_names VARCHAR(40),
	ensemble_ids VARCHAR(45),
	pvalue1 FLOAT,
	pvalue2 FLOAT,
	pvalue3 FLOAT,
	pvalue4 FLOAT,
	pvalue5 FLOAT,
	pvalue6 FLOAT,
	pvalue7 FLOAT,
	log2FC1 FLOAT,
	log2FC2 FLOAT,
	log2FC3 FLOAT,
	log2FC4 FLOAT,
	log2FC5 FLOAT,
	log2FC6 FLOAT,
	log2FC7 FLOAT
) engine = innodb;

select gid, '1' as eid, Log2FC1,PValue1,Log2FC2,PValue2,Log2FC3,PValue3,Log2FC4,PValue4,Log2FC5,PValue5,Log2FC6,PValue6,Log2FC7,PValue7
from Gene join temptable using(ensemble_ids)
limit 5;

insert into Expression (gid, eid,log2FC1, pvalue1, log2FC2, pvalue2, log2FC3, pvalue3, log2FC4, pvalue4,log2FC5, pvalue5,log2FC6, pvalue6,log2FC7, pvalue7)
select gid, '1' as eid,Log2FC1,PValue1,Log2FC2,PValue2,Log2FC3,PValue3,Log2FC4,PValue4,Log2FC5,PValue5,Log2FC6,PValue6,Log2FC7,PValue7  
from Gene join temptable using(ensemble_ids);
 
LOAD DATA LOCAL INFILE '/home/students_22/amustaki/finalproject/paper_processed.csv' INTO TABLE temptable FIELDS TERMINATED BY ',' IGNORE 1 LINES (ensemble_ids,gene_names,Log2FC1,PValue1,Log2FC2,PValue2,Log2FC3,PValue3,Log2FC4,PValue4,Log2FC5,PValue5,Log2FC6,PValue6,Log2FC7,PValue7);





with cte as (
	select 
		gid, 
		gene_names, 
		ensemble_ids, 
		row_number() over (
			partition by 
				gene_names, 
				ensemble_ids 
			order by 
				gene_names, 
				ensemble_ids
		) row_num 
	from 
		Gene
) 
delete from cte 
where row_num > 1;








with cte (gid, gene_names, ensemble_ids, duplicatecount)
as (select gene_names, ensemble_id, row_number() over(partition by gene_names, ensemble_ids order by gid) as duplicatecount from Gene delete from cte where duplicatecount > 1;



'''how the duplicate values were found in the gene table '''
select gid, gene_names, ensemble_ids, count(*)
from Gene
group by gene_names, ensemble_ids 
having count(*) > 1






'''how the duplicates were dropped '''
DELETE FROM Gene 
WHERE 
    ensemble_ids IN (
    SELECT 
        ensemble_ids 
    FROM (
        SELECT                         
            ensemble_ids,
            ROW_NUMBER() OVER (
                PARTITION BY emsemble_ids
                ORDER BY ensemble)) AS row_num
        FROM 
            Gene
    ) s_alias
    WHERE row_num > 1
);

























