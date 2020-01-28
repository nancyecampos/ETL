-- create tables to insert data from jupyter notebook
drop table outbreak;
CREATE TABLE outbreak (
year int,
stateid TEXT,
primarymode TEXT,
etiology TEXT,
setting TEXT,
illness Int
);

drop table death;
CREATE TABLE death (
stateid TEXT,
cause TEXT,
deaths INT,
population INT
);
select distinct stateid,population into population 
from death;

-- where etiology is blank set as unknown
begin transaction;
update outbreak
set etiology = 'Unknown'
where etiology is null;
commit;

-- check to see if above worked
select distinct etiology from outbreak order by etiology desc

-- delete states that do not appear in both datasets
begin transaction;
delete from outbreak where stateid in ('Republic of Palau','Puerto Rico', 'Vermont', 'New Mexico', 'Hawaii', 'South Dakota', 'Iowa', 'Multistate', 'Montana', 'Wyoming', 'North Dakota', 'Nebraska', 'Maine', 'Idaho', 'Alaska')
commit;

-- update DC in outbreak to reflect WashDC in in both datasets
update outbreak
set stateid ='District of Columbia'
where stateid ='Washington DC'

-- check to see if above worked (states should match in both sets)
select distinct stateid from outbreak order by stateid desc
select distinct stateid from death order by stateid desc


-- adding population per state in the outbreak database
select pop.stateid,ob.etiology ,ob.illness , pop.population into Illness from outbreak ob 
left join 
population pop
on ob.stateid = pop.stateid;

-- use a union to join both datasets and mark each original dataset to be able to distinguish orignial data
select count(*) from(
select 'Ill' as Rermark, stateid,etiology,illness,population from illness
union
select 'Death' as Rermark, stateid,cause, deaths,population from death 
) a;

-- new table with all data together (final product)
Select * into death_illness_cause_population from 
(select 'Ill' as Rermark, stateid,etiology as cause,illness as count,population from illness
union
select 'Death' as Rermark, stateid,cause, deaths,population from death 
) a;

-- show type of data grouped by remark
select Rermark,count(*) from death_illness_cause_population
group by Rermark

-- order by state 
select Rermark,stateid,count(*) from death_illness_cause_population
group by Rermark, stateid
order by 2,1,3 desc ;

-- show count of illness or death by state
select stateid,count(*) from death_illness_cause_population
group by stateid
order by count desc ;

