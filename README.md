# CoreDataEngineers Data Engineering Bootcamp: Git and Linux Assignment

## Overview
This repository documents the solution for the CoreDataEngineer Bootcamp Assignment. I have been saddled as a Data Engineer to manage the company's data infrastructure (based on Linux Operating system) and version control tool.

## Tasks
### First Task: ETL process of a financial dataset.
1. Build a Bash script that performs a simple ETL process.
**Instruction:** Extracted, transformed, loaded data are to be saved into the raw, transformed and gold directory respectively.
The data url was assigned to a variable ````data_url```` then I used Curl command to download the data.
```data_extract=$(curl - # "$data_url)```

I renamed the file by appending the current date for tracking to ensure daily runs: ```annual-enterprise-survey-2023-financial-year-provisional_"$current_date".csv```

After downloading the data and renaming the csv file, I used an array to create the directories; raw, transformed and gold and used an ```If and For loops condition``` iterate the creation of the directions.

The raw data file was moved into the raw directory.

2. Rename column named Variable_code to variable_code. Then select only the following columns: year, value, units, variable_code.

Using ```ls -t``` to list the most recent files for confirmation and then fetch the most recent file (this is putting in consideration that the ETL process is a continuous one).
```sed command``` was used to convert the case of the column Variable_name to variable_name.
```AWK command``` was used to select the appropriate columns from the data set and the output was added to the a file named 2023_year_finance.csv

3. Load transformed data
The transformed file was then moved into the gold directory

4. Create a cronjob script to automate the ETL process everyday at 12:00
I used the syntax ```cron``` to schedule the etl-process-script to run at 12am midnight (0 0 * * *); The first number is in minutes, The second number is in hours and reads in 24-hour format with 12am as 0 whilst the * means daily, every month, day of the week.

### Second Task
Create a bash script to move all CSV and JSON files from one directory to another
I used the ```find``` command to locate all ```*.csv, *.json``` files in the source directory with -maxdepth flag which can always be changed depending on the level of depth in scenarios where there are sub-directories. Then I moved the files to the target directory. 

### Third task: Analysis of Parch and Posey sales data
1. Write a bash script that iterates over and copies each of the CSV files into a PostgreSQL database named posey
I used the ```psql``` command to create the database and its tables and the ```basename``` command was used to remove the directory path and suffix (extension) from the file names. Then I used the file names in a ```for loop and if conditional statements``` to select corresponding database column name and import the data accordingly.

2. SQL Answers
## SQL Scripts that answers the questions posed by the manager; Ayoola.

- /* Find a list of order IDs where either `gloss_qty` or `poster_qty` is greater than 4000. Only include the `id` field in the resulting table. */


**Result:**
```sql
SELECT id
FROM orders
WHERE gloss_qty > 4000 OR poster_qty > 4000;
```

id | 
--| 
362 | 
731 | 
1191 | 
1913 |
1939 | 
3778 | 
3858 | 
3963 | 
4016 | 
4230 |
4698 | 
4942 | 
5791 | 
6590 | 

*14 Order ids had either **gloss_qty** or **poster_qty** greater than 4000.*


- /* Write a query that returns a list of orders where the `standard_qty` is zero and either the `gloss_qty` or `poster_qty` is over 1000. */

**Result:**

```sql
SELECT *
FROM orders
WHERE standard_qty = 0 
  AND (gloss_qty > 1000 OR poster_qty > 1000);
```

| id | account_id | occurred_at | standard_qty | gloss_qty | poster_qty | total | standard_amt_usd | gloss_amt_usd | poster_amt_usd | total_amt_usd |
|----|------------|-------------|--------------|-----------|------------|-------|------------------|---------------|----------------|---------------|
|    |            |             |              |           |            |       |                  |               |                |               |

*No orders had a **standard_qty** of zero and either a **gloss_qty** or **poster_qty** greater than 1000. However, there were null values in the **standard_qty** column that could have been given a default of 0 in a scenario of data transformation*


- /* Find all the company names that start with a '**C**' or '**W**', and where the primary contact contains '**ana**' or '**Ana**', but does not contain '**eana**'. */

**Result:**

```sql
SELECT name
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
	AND (primary_poc LIKE '%ana%' OR primary_poc LIKE 'Ana%')
	AND (primary_poc NOT LIKE '%eana%');
```

name | 
--| 
CSV Health | 
Comcast | 
     
*Only two companies had their names starting with a **C** or **W**, where the primary contacts contained '**ana**' or '**Ana**', but not '**eana**'.*


- /* Provide a table that shows the region for each sales rep along with their associated accounts. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) by account name. */

**Result:**

```sql
SELECT accounts.name AS account_name, sales_reps.name AS sales_rep, region.name AS region 
FROM accounts
JOIN sales_reps
ON sales_reps.id = accounts.sales_rep_id
JOIN region
ON region.id = sales_reps.region_id
ORDER BY account_name;
```
| region_name | sales_rep_name       | account_name              |
|-------------|-----------------------|---------------------------|
| Northeast   | Sibyl Lauria          | 3M                        |
| Southeast   | Earlie Schleusner     | ADP                       |
| Southeast   | Moon Torian           | AECOM                     |
| Southeast   | Calvin Ollison        | AES                       |
| Northeast   | Elba Felder           | AIG                       |
| Northeast   | Necole Victory        | AT&T                      |
| Midwest     | Julie Starr           | AbbVie                    |
| Midwest     | Chau Rowles           | Abbott Laboratories       |
| West        | Marquetta Laycock     | Advance Auto Parts        |
| Northeast   | Renetta Carew         | Aetna                     |

*The result is a snippet of the total number of rows **351 rows**.*
