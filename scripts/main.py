import os
from .extract_s3 import run as run_s3
from .extract_postgres import run as run_pg
from .extract_g_sheets import run as run_gs

EXTRACT_MODE = os.getenv("EXTRACT_MODE", "all")

def main():
    print(f"Running extraction mode: {EXTRACT_MODE}")

    if EXTRACT_MODE == "all":
        run_s3()
        run_pg()
        run_gs()

    elif EXTRACT_MODE == "s3":
        run_s3()

    elif EXTRACT_MODE == "postgres":
        run_pg()

    elif EXTRACT_MODE == "gsheets":
        run_gs()

    else:
        raise ValueError(f"Unknown EXTRACT_MODE: {EXTRACT_MODE}")

if __name__ == "__main__":
    main()
