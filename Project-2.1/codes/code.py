import pandas as pd
import os

folder_path = r"D:\Studying\Data Analyst Projects\Project 2.1\Data"

csv_files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

for file in csv_files:
    csv_path = os.path.join(folder_path, file)
    parquet_path = os.path.join(folder_path, file.replace('.csv', '.parquet'))
    
    print(f"Converting {file} to Parquet format...")
    df = pd.read_csv(csv_path)
    df.to_parquet(parquet_path,engine='pyarrow', index=False)
    
print ("Conversion completed.")