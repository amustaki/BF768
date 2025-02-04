''' List the number of unique miRNAs with a score less than -0.6 in the targets table '''
select count(distinct(mid))
from targets 
where score < -0.6;

