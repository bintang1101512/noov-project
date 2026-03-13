FROM python:3.11-slim

WORKDIR /app

COPY ingestion/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install dbt-bigquery

COPY . .

ENV DBT_PROFILES_DIR=/app/transform

CMD ["python", "pipeline.py"]