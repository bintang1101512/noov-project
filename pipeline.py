from datetime import datetime
import subprocess

def run_step(name, command, cwd=None):
    print(f"[{datetime.now()}] Start {name}")
    subprocess.run(command, cwd=cwd, check=True)
    print(f"[{datetime.now()}] End {name}")

now = datetime.now()

run_step(
    "ingestion",
    ["python", "ingestion/main.py"]
)

run_step(
    "ingestion_box",
    ["python", "ingestion_box/main.py"]
)

if now.hour == 1 and now.minute < 10:
    run_step(
        "ingestion_vp",
        ["python", "ingestion_vp/main.py"]
    )

run_step(
    "dbt build",
    ["dbt", "build"],
    cwd="transform/projects"
)