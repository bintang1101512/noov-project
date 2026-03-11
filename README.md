# Noovoleum Data Pipeline

## Overview

This project implements a simple data pipeline that extracts data from an API, loads it into BigQuery, and transforms it using dbt.

## Architecture

API → Python Ingestion → BigQuery (Raw) → dbt Transform → Looker/Power BI

## Project Structure

```
noovoleum-project
│
├── ingestion/
│   ├── config.py
│   ├── extract.py
│   ├── load.py
│   ├── big_query_utils.py
│   └── main.py
│
├── transform/        # dbt project
├── pipeline.py       # run ingestion + dbt
├── Dockerfile
└── .gitignore
```

## Run Pipeline

```
python pipeline.py
```

## Technologies

Python • BigQuery • dbt • Docker

## Author

Risky Bintang Munggaran
