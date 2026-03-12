import requests
from config import API_URL, MAX_RETRY
import logging
import json
import time

logging.basicConfig(level=logging.INFO)

def extract(token):

    headers = {
        "Authorization" : f"Bearer {token}",
        "accept" : "application/json"
    }

    for attempt in range(1, MAX_RETRY +1):
        try:
            logging.info(f"req API... attemp {attempt}")

            resp = requests.get(
                url=API_URL,
                headers=headers,
                timeout=(1,60)
            )

            if resp.status_code != 200:
                logging.warning(f"Req gagal resp api: {resp.status_code} !!!")

            data = resp.json()
            
            logging.info(f"TOTAL DATA: {len(data)}")

            for row in data:
                yield row

            return
        
        except Exception as e:
            logging.warning(f"API Error: {e}")
            if attempt == MAX_RETRY:
                raise
            time.sleep(3)

            
