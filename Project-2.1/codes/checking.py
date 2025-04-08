import pandas as pd
import duckdb

dfCheck = duckdb.query(r"SELECT * FROM 'D:\Studying\Data Analyst Projects\Project 2.1\Data\202004-divvy-tripdata.parquet' LIMIT 100").to_df()

#print(dfCheck)

print(dfCheck)