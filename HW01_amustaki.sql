--Homework 1 Athena Mustakis 
--question one creating the tables for question 1 

create table Team(
	tid integer not null auto_increment,
	team_name varchar(75),
	stadium varchar(120),
	city varchar(100),
	primary key(tid)
) engine = innodb;

create table Player(
	pid integer not null auto_increment,
	player_name varchar(100),
	jersey integer, 
	position varchar(100),
	primary key(pid)
) engine = innodb;

create table Coach(
	cid integer not null auto_increment,
	coach_name varchar(45),
	end date, 
	primary key(cid)
) engine = innodb;

create table Has(
	tid integer not null,
	cid integer not null,
	primary key(tid),
	foreign key (tid) references Team(tid),
	foreign key (cid) references Coach(cid)
	) engine = innodb;
	
create table Playsfor(
	pid integer not null,
	tid integer not null,
	primary key(pid),
	foreign key(pid) references Player(pid),
	foreign key(tid) references Team(tid)
	) engine = innodb;

create table Game(
	hid integer not null, 
	aid integer not null,
	week_number integer,
	home_qb varchar(50),
	away_qb varchar(50),
	primary key(hid),
	foreign key(hid) references Team(tid),
	foreign key(aid) references Team(tid)
	) engine = innodb;
	
--question 2 insert statements 
-- insert statments: 4 teams, 8 players, 1 coach for each team, 3 games 

insert into Team (team_name, stadium, city)
values ('Cincinnati Bengals', 'Paul Brown','Cincinnati,OH'),
('Buffalo Bills', 'Highmark', 'Buffalo,NY'),
('Green Bay Packers', 'Lambeau Field', 'Green Bay,WI'),
('Los Angeles Rams','SoFi', 'Los Angeles');

insert into Player(player_name,jersey, position)
values('Joe Burrows', 9 , 'Quarterback'),	
('JaMarr Chase', 1 , 'Wide Receiver'),
('Josh Allen', 17 , 'Quarterback'),
('Stefon Diggs', 14 , 'Wide Receiver'),
('Aaron Rodgers', 12, 'Quarterback'),
('Davante Adams', 17, 'Wide Receiver'),
('Matthew Stafford', 9 , 'Quarterback'),
('Cooper Kupp', 10, 'Quarterback');

insert into Coach(coach_name,end)
values('Zac Taylor', 20250925),
('Sean McDermott', 20240614),
('Matt LaFleur', 20240918),
('Sean McVay', 20281222);

insert into Has(tid,cid)
values(1,1),
(2,2),
(3,3),
(4,4);

insert into Playsfor(pid,tid)
values(1,1),
(2,1),
(3,2),
(4,2),
(5,3),
(6,3),
(7,4),
(8,4);

insert into Game(hid,aid, week_number, home_qb, away_qb)
values(2,1,1,"Josh Allen", "Joe Burrows"),
(4,3,3, "Matthew Stafford", "Aaron Rodgers"),
(3,2,6, "Aaron Rodgers", "Josh Allen");

--question 3 writing select statements
--part a list all teams
select team_name,stadium,city from Team;

--part b list all quarterbacks
select player_name from Player
where position = "Quarterback";

--part c list each coach(name, team, contract_end) in descending order by contract end date
select coach_name,team_name,end
from Has join Coach using(cid) join Team using(tid)
order by end desc;

--part d list all players(name, position, team_name) in alphabetical order by team name and then player name 
select player_name,position,team_name
from Playsfor join Player using(pid) join Team using(tid)
order by team_name ASC, player_name ASC;

--part e list each game(home team name, away team name, stadium, week) in order by ascending 
--assign variables for the home and away in order to tell them apart 
--only need stadium name of the home team because that is where you are playing
select t1.team_name as home_team, t2.team_name as away_team, t1.stadium, g.week_number
from Game g, Team t1, Team t2
where t1.tid=g.hid and t2.tid=g.aid
order by week_number ASC;

