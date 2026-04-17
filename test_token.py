import requests
import pandas as pd
import json

api_url = "https://api.noovoleum.com/api/admin/engineer/getBoxes"

headers = {
    "Authorization" : "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiI2ODcwNzcyNzZhNTg0MWE5MDBlNTJlZjAiLCJpYXQiOjE3NzU0MjU2MDcsImV4cCI6MTc3ODAxNzYwN30.jOJtJ-StoJYqlb-GBRCOQGop3NQ8k3J_qZLoIBoT2Y8",
    "Accept" : "application/json",
    "x-country" : "th"
}

resp = requests.get(url=api_url, headers=headers)
data = resp.json()

df = pd.json_normalize(data)
print(df.columns)

