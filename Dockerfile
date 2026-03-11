FROM python:3.11-slim

WORKDIR /app

COPY ingestion/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install dbt-bigquery

COPY . .

WORKDIR /app

CMD ["python", "pipeline.py"]