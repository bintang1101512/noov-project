import subprocess

print("Start ingestion")

subprocess.run(["python", "ingestion/main.py"], check=True)

print("Start dbt")

subprocess.run(["dbt", "build"],cwd="transform/projects", check=True)