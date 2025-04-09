import os
import duckdb
import pandas as pd

folder_path = r"D:\Studying\Data Analyst Projects\Project 2.1\Data"

parquet_files = [f for f in os.listdir(folder_path) if f.endswith('.parquet')]

all_data = []

for file in parquet_files:
    full_path = os.path.join(folder_path, file).replace("\\", "/")
    print(f"Reading {full_path}...")
    df = duckdb.query(f"SELECT * FROM '{full_path}'").to_df()
    
    df["source_file"] = file
    all_data.append(df)
    
combined_df = pd.concat(all_data, ignore_index=True)
print("All data combined.")
output_path = os.path.join(folder_path, "combined_data.parquet").replace("\\", "/")

# Convert ID columns to string
# because parquet files are not compatible with int64
# and duckdb will convert them to int64
combined_df['start_station_id'] = combined_df['start_station_id'].astype(str)
combined_df['end_station_id'] = combined_df['end_station_id'].astype(str)

# Save to parquet
combined_df.to_parquet(output_path, engine="pyarrow", index=False)

output_path = os.path.join(folder_path, "combined_data.parquet").replace("\\", "/")
combined_df.to_parquet(output_path, engine="pyarrow", index=False)
print(f"Combined data saved to {output_path}.")