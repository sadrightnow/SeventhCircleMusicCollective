import csv
import json

csv_file_path = 'update.csv'
json_file_path = 'update.json'

data = []

with open(csv_file_path, mode='r', encoding='utf-8-sig') as csv_file:
    csv_reader = csv.DictReader(csv_file, fieldnames=['event_date', 'event_name'])
    for row in csv_reader:
        data.append({
            "event_date": row['event_date'].strip(),
            "event_name": row['event_name'].strip()
        })

with open(json_file_path, mode='w', encoding='utf-8') as json_file:
    json.dump(data, json_file, indent=2, ensure_ascii=False)

print(f"✅ Data successfully converted to {json_file_path}")
