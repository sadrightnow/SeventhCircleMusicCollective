import csv
import json

# Load the CSV file
csv_file_path = 'events.csv'
json_file_path = 'events.json'

data = []

# Read the CSV and convert to a list of dictionaries
with open(csv_file_path, mode='r') as csv_file:
    csv_reader = csv.DictReader(csv_file)
    for row in csv_reader:
        # Append each row as a dictionary to the list
        data.append({
            "event_date": row['event_date'],
            "event_name": row['event_name']
        })

# Write the data to a JSON file
with open(json_file_path, mode='w') as json_file:
    json.dump(data, json_file, indent=2)

print(f"Data successfully converted to {json_file_path}")