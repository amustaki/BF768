'''List the top 10 miRNA pairs with the most gene targets in common (miRNA id #1, miRNA name #2, miRNA name #2, count)'''

select A.name as miRNA1, A.mid as mid1, B.name as mirna2, B.mid as mid2, gid_count 
from 
(select count(*) gid_count, mid1,mid2,gid 
from(
select A.mid as mid1, B.mid as mid2, A.gid
from targets A join targets B on A.gid = B.gid and A.mid < B.mid )
pairs
group by mid1, mid2
order by count(*) desc
limit 10) new_table
left join miRNA A on A.mid = mid1 
left join miRNA B on B.mid = mid2;


