-- Database: sql_auto3

-- DROP DATABASE IF EXISTS sql_auto3;

CREATE DATABASE sql_auto3
    WITH
    OWNER = postgres
    ENCODING = 'WIN1252'
    LC_COLLATE = 'Spanish_Paraguay.1252'
    LC_CTYPE = 'Spanish_Paraguay.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
CREATE TABLE countries(
id INTEGER,
name VARCHAR,
iso3 CHAR(3),
capital VARCHAR,
currency CHAR(3),
currency_name VARCHAR,
tid CHAR(3),
region VARCHAR,
subregion VARCHAR,
latitude DECIMAL(10,8),
longitude DECIMAL(11,8)
);
CREATE TABLE states(
id INTEGER,
name VARCHAR,
country_id INTEGER,
state_code CHAR(5),
state_type VARCHAR,
latitude DECIMAL(10,8),
longitude DECIMAL(11,8)
);
CREATE TABLE cities(
id INTEGER,
name VARCHAR,
state_id INTEGER,
latitude DECIMAL(10,8),
longitude DECIMAL(11,8)
);
--select countries.name, count(states.name) as counts from countries inner join states on countries.id=states.country_id
--group by countries.name

--select countries.name,states.name,states.latitude from countries inner join states on countries.id=states.country_id
--where states.latitude is not null
--order by latitude desc
--limit 3;

--select count(*) from countries inner join states on countries.id=states.country_id
--select count(*) from countries left join states on countries.id=states.country_id
select states.name, count(cities.name) as counts from states inner join cities on states.id= cities.state_id
group by states.name
order by counts desc
limit 5;

