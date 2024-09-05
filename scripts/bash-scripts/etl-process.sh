#This bash script is to extract, transform and load the data from https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv
#!/bin/bash

#create environment variables for the directories to be able to make directories and scripts without inserting the absolute paths
#this script is in the assignment directory
parent_dir=$HOME/Documents/cde_ass
echo $parent_dir

## Extraction
#Create a variable to hold the url
data_url="https://www.stats.govt.nz/assets/Uploads/Annual-enterprise-survey/Annual-enterprise-survey-2023-financial-year-provisional/Download-data/annual-enterprise-survey-2023-financial-year-provisional.csv"

#Make the variable global so that it can be called from the cron script
export data_url

echo "extracting the 2023 financial year provisional data"
#Extract the data using curl command
data_extract=$(curl -# "$data_url")

#Get today's date to track daily data ingestion
current_date=$(date +"%Y-%m-%d")

#print out the output to the file with today's date appended to the name of the file
echo "$data_extract" > annual-enterprise-survey-2023-financial-year-provisional_"$current_date".csv

#create a variable for the file name
extracted_file=annual-enterprise-survey-2023-financial-year-provisional_"$current_date".csv

#create a raw, transformed and gold directories if they do not exist as this script is supposed to be a continuous process
target_dir=("raw" "transformed" "gold")

if [ -d "$parent_dir" ]; then
    cd "$parent_dir"
    echo "you are in the $parent_dir"
    #
    for folder in "${target_dir[@]}"; do
        if [ ! -d "$folder" ]; then
            mkdir "$folder"
            echo "Directory $folder was created."
        else
            echo "Directory $folder already exists."
        fi
    done
else
    echo "Directory $parent_dir does not exist."
fi

#Creating variables for the directories created.
raw_dir="$parent_dir/raw"
transformed_dir="$parent_dir/transformed"
gold_dir="$parent_dir/gold"

#Move extracted file into raw directory
mv "$extracted_file" "$raw_dir"
echo "$extracted_file has been downloaded and moved into the $raw_dir directory"

#list out the directory to confirm that the file exists
ls "$raw_dir"

echo "data extraction completed"

#view the top 10 lines
echo "displaying the top ten lines"
head -n 10 "$target_dir/$extracted_file"

#Transform
echo "Transformation starts"

#List the three most recent files
ls -t $raw_dir

#Fetch the most recent file.
latest_raw_file=$(ls -t "$raw_dir" | head -n 1)

#Confirm the first three lines of the file
head -n 3 "$raw_dir"/"$latest_raw_file"

#change case of Variable_code to variable_code in the first occurrence (header)
sed '1s/Variable_code/variable_code/' "$raw_dir"/"$latest_raw_file" > "$raw_dir"/modified_file.csv

#Confirm the case update
head -n 3 "$raw_dir"/modified_file.csv

#Extract the year, value, unit, variable_code columns from the file and move it to the transformed folder
echo "Extracting the year, value, unit and variable_code columns and moving the updated file to the $transformed directory"
awk -F',' '{print $1","$5","$6","$9}' "$raw_dir"/modified_file.csv > "$transformed/2023_year_finance.csv"
echo "file has been renamed to 2023_year_finance.csv"

#remove the temporary file created
rm "$raw_dir"/modified_file.csv

#Confirm file exists in the transformed directory
ls $transformed
head -n 3 $transformed/2023_year_finance.csv

#Loading process
echo "Loading 2023_year_finance.csv file to $gold_dir directory"
check_file=$(cp $transformed/2023_year_finance.csv $gold_dir)

if [ "$check_file" = 'f' ]; then
    echo "file is not in $gold_dir directory"
else
    echo "file has been moved to gold directory"
    ls $gold_dir
fi

echo "ETL process completed"