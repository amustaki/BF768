'''List all genes targeted by the let-7c miRNA, not not targeted by miR-16 (gene id name) no duplicate rows '''

select gid, g.name
from gene g join targets t using (gid) join miRNA m using (mid)
where m.name regexp 'let-7C' and gid not in (select m.name from gene g join targets t using (gid) join miRNA using (mid) where m.name regexp 'miR-16');

