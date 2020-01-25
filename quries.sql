-- next class: organize sql queries, re-run juypter notebook, merge two tables to compare number of illness and number of deaths by state
drop table outbreak;
CREATE TABLE outbreak (
year int,
stateid TEXT,
primarymode TEXT,
etiology TEXT,
setting TEXT,
illness Int
);


select count(*) from(
select 'Ill' as Rermark, stateid,etiology,illness, 0 pop from outbreak
union
select 'Death' as Rermark, * from death 
) a;

drop table death;
CREATE TABLE death (
stateid TEXT,
cause TEXT,
deaths INT,
population INT
);
select distinct stateid,population into population 
from death;

begin transaction;
update outbreak
set etiology = 'Unknown'
where etiology is null;
commit;

select pop.stateid,ob.etiology ,ob.illness , pop.population into Illness from outbreak ob 
left join 
population pop
on ob.stateid = pop.stateid;


select stateid,etiology,sum(illness) illnessCount from Illness
group by stateid,etiology
order by 3 desc;


select * from outbreak;

--second query box !!!!

select distinct stateid from death where stateid  not in (
select distinct stateid from outbreak);

--this is how to see which states are not on the death dataset 
select distinct stateid from outbreak  where stateid  not in (
select distinct stateid from death);

--how to update DC
update outbreak
set stateid ='District of Columbia'
where stateid ='Washington DC'

select * from outbreak where stateid in (select distinct stateid from outbreak  where stateid  not in (
select distinct stateid from death))

--this is how to delete states we don't need
begin transaction;
delete from outbreak where stateid in ('Republic of Palau','Puerto Rico', 'Vermont', 'New Mexico', 'Hawaii', 'South Dakota', 'Iowa', 'Multistate', 'Montana', 'Wyoming', 'North Dakota', 'Nebraska', 'Maine', 'Idaho', 'Alaska')

rollback