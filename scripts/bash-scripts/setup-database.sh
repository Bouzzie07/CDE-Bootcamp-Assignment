#Create a database.
psql -U postgres -c "Create Database posey;"

#Create the tables
table_script=$HOME/Documents/cde_ass/scripts/sql-scripts
psql -d posey -f "$table_script"/setup-tables.sql

#Create a variable for the csv directory
csv_data=$HOME/Documents/cde_ass/csv_data

#Create a For Loop to iterate the csv files
for csv_file in "$csv_data"/*.csv; do

	#remove the directory path and get the file name only using string manipulation
	modified_file=$(basename "$csv_file" | cut -d "." -f 1)

	echo "$modified_file"

	 #Check if table exists and select table name corresponding to file name from database
	table_name=$(psql -d posey -tAc "SELECT EXISTS (
	    SELECT 1 FROM pg_catalog.pg_tables 
	    WHERE schemaname='public'
	    AND tablename='$modified_file');")

	if [ "$table_name" = 't' ]; then
		psql -d posey -c "\Copy $modified_file FROM '$csv_file' DELIMITER ',' CSV HEADER;"
		psql -d posey -C "SELECT COUNT(*) FROM $modified_file"
		echo "Data imported successfully into table: $modified_file"
	else
		echo "Table $modified_file does not exist."
	fi
	
	#Cross-check if the number of lines in the file tallies with the rows in the table
	count_csv_lines=$(wc -l "$csv_file")


done

#Alter the appropriate tables to add the constraints
psql -d posey -f "$table_script"/alter_tables_constraints.sql

