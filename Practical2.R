install.packages(c("sqldf","RSQLite","DBI"))
library(sqldf)
library(RSQLite)
library(dplyr)
library(DBI)
library(ggplot2)
library(nycflights13)

flights_df <- as.data.frame(flights)
write.csv(flights_df,"flights_data.csv",row.names = FALSE)
flights_data <- read.csv("flights_data.csv")
con <- dbConnect(RSQLite::SQLite(),"flights_db.sqlite")
dbWriteTable(con,"flights",flights_data,overwrite = TRUE)
filtered_data <- dbGetQuery(con,"SELECT* FROM flights WHERE origin = 'JFK' AND air_time >300")
print(filtered_data)

airlines_df <- as.data.frame(airlines)
dbWriteTable(con,"airlines",airlines_df,overwrite = TRUE)
joined_data <- dbGetQuery(con,"
                          SELECT flights.*,airlines.name
                          FROM flights
                          INNER JOIN airlines ON flights.carrier =  airlines.carrier")
print(joined_data)

summarized_data <- dbGetQuery(con,"
                              SELECT carrier,AVG(air_time) AS avg_air_time
                              FROM flights
                              GROUP BY carrier
                              ")
print(summarized_data)


ggplot(summarized_data,aes(x=carrier,y=avg_air_time,fill=carrier))+
  geom_bar(stat = "identity")+
  theme_minimal()+
  labs(title = "Avg air time",x="Airline Carrier",y="Avg Air Time(minutes)")


ordered_flights <- dbGetQuery(con,"
                              SELECT *
                              FROM flights
                              ORDER BY distance DESC
                              ")
print(ordered_flights)

count_by_origin <- dbGetQuery(con,"
                              SELECT origin, COUNT(*) AS total_flights
                              FROM flights
                              GROUP BY origin
                              ORDER BY total_flights DESC
                              ")
print(count_by_origin)


distinct_carriers <- dbGetQuery(con,"
                                SELECT DISTINCT carrier
                                FROM flights
                                ")
print(distinct_carriers)


long_flights <- dbGetQuery(con,"
                           SELECT *
                           FROM flights
                           WHERE air_time > 300
                           ")
print(long_flights)

dbExecute(con, "
          CREATE TABLE short_flights AS
          SELECT * FROM flights WHERE air_time < 60
          ")
dbExecute(con, "DELETE FROM flights WHERE distance < 100")
dbExecute(con, "ALTER TABLE flights ADD COLUMN speed REAL")
dbExecute(con, "
            UPDATE flights
            SET speed = distance * 60.0 / air_time
            WHERE air_time IS NOT NULL
            ")
union_example <- dbGetQuery(con,"
                            SELECT flight, origin, dest, air_time, 'Short' AS category
                            FROM flights
                            WHERE air_time < 60
                            
                            UNION

                            SELECT flight, origin, dest, air_time, 'Long' AS category
                            FROM flights
                            WHERE air_time > 300
                            ")
print(union_example)
dbDisconnect(con)
