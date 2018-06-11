--listing file
hadoop fs -ls /user/maria_dev

--copying data to hdfs
hadoop fs -put 'cities_small.txt' /user/maria_dev/
hadoop fs -put 'states.txt' /user/maria_dev/

--checking file
hadoop fs -ls /user/maria_dev

--loading city data into a cities relation. By default 'TAB' is the delimiter.
cities = LOAD 'cities_small.txt' as (city:chararray, state:chararray, population:int);

--checking list of relations
aliases;

--showing results. Results are tuples.
dump cities;

--store the result. A folder is created in hdfs path, file is stored underneath it.
STORE cities into 'cities_stored'

--checking the relation type
describe cities;

--selecting random data
illustrate cities;

--filtering data
cities_filtered = FILTER cities by (state=='CA');
cities_filtered = FILTER cities by (population>=1000000);

--order by
cities_ordered = ORDER cities by population DESC;
top5_cities = limit cities_ordered 5;

--join
states = LOAD 'states.txt' as (no:int, code:chararray, fullname:chararray, month:chararray, year:int);

states_joined = JOIN cities by state, states by code;

--FOREACH GENERATE
states_joined_selected_columns = FOREACH states_joined GENERATE (cities::city,states::fullname);

OR

states_joined_selected_columns = FOREACH (JOIN cities by state, states by code) GENERATE (cities::city, states::fullname);

multiply_population = FOREACH cities GENERATE city,population * 2;

--GROUP BY
cities_grouped = GROUP cities BY state;

cities_avg_population = FOREACH cities_grouped {
								state = group;
								average = AVG(cities.population);
								GENERATE state,average;
								};

OR

cities_avg_population = FOREACH cities_grouped GENERATE group,AVG(cities.population) as avgpop;

order_avg_population = ORDER cities_avg_population BY avgpop DESC;

top5_avg_popualtion = LIMIT order_avg_population 5;

