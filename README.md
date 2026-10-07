# Netflix Content Analysis Using SQL

## Overview
This project uses MySQL to explore a dataset of Netflix movies and TV shows. The analysis examines content types, countries, genres, ratings, durations, and release trends.

## Tools
- MySQL
- MySQL Workbench

## Project Files
- Netflix_data.sql — SQL questions and analysis queries.
- Netflix_Data.csv — Dataset used for the analysis.

## Questions Explored
1. How many movies and TV shows are in the dataset?
2. Which country entries have the most content?
3. Which titles were released in 2020?
4. Which movies were directed by Kirsten Johnson?
5. What is the most common content rating?
6. Which TV shows have five or more seasons?
7. Which Indian movies belong to the comedy category?
8. How many titles were released each year?
9. Which directors have the most movies?
10. In which year was the most content added?
11. Which Indian movies are the oldest?
12. Which documentaries were released after 2015?
13. Which movies have the longest durations?
14. What are the latest movie releases by country entry?
15. Which release years have more than 50 Indian movies?

## SQL Skills Demonstrated
- Filtering with WHERE
- Aggregation with COUNT
- Grouping with GROUP BY
- Filtering grouped results with HAVING
- Sorting with ORDER BY
- Pattern matching with LIKE
- String functions and type conversion
- Common Table Expressions (CTEs)
- Window functions

## How to Run
1. Download the CSV and SQL files.
2. Open MySQL Workbench and connect to your MySQL server.
3. Create and select the netflix_database database.
4. Import Netflix_Data.csv using the Table Data Import Wizard.
5. Name the imported table netflix_data.
6. Open Netflix_data.sql and execute the analysis queries.

Use MySQL 8.0 or later for CTEs and window functions.

## Analysis Notes
- Results describe the supplied dataset, rather than Netflix's current catalogue.
- Movie durations are measured in minutes; TV show durations are measured in seasons.
- Country entries are analysed as stored. An entry containing multiple countries is treated as one combination.
- Missing country or director information can affect rankings.

## Author
Thabo Dylan Ncube
