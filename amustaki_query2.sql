'''List the top 10 miRNAs with the most targeted genes (miRNA id, miRNA name, count)'''
select mid, m.name, count(*)
from gene g join targets t using(gid) join miRNA m using(mid)
group by(m.name)
order by count(*) desc
limit 10;