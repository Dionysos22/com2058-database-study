#!/usr/bin/env python3
"""
COM2058 ogrenme: Python + pymysql ile ham SQL.
Calistir (Docker + .env ayarli):
  cd Project/UPLOAD_READY
  source .venv/bin/activate
  python scripts/ogrenme_python_mysql.py
"""
from __future__ import annotations

import os
import sys

try:
    import pymysql
    from pymysql.cursors import DictCursor
except ImportError:
    print("pymysql yok: pip install pymysql")
    sys.exit(1)

HOST = os.getenv("DB_HOST", "127.0.0.1")
PORT = int(os.getenv("DB_PORT", "3306"))
USER = os.getenv("DB_USER", "f1user")
PASSWORD = os.getenv("DB_PASSWORD", "f1pass")
DB = os.getenv("PROJECT_DB_NAME", "formula_1")


def run(sql: str, params: tuple = ()) -> list[dict]:
    conn = pymysql.connect(
        host=HOST,
        port=PORT,
        user=USER,
        password=PASSWORD,
        database=DB,
        charset="utf8mb4",
        cursorclass=DictCursor,
    )
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            return list(cur.fetchall())
    finally:
        conn.close()


def main() -> None:
    print(f"Baglanti: {USER}@{HOST}:{PORT}/{DB}\n")

    print("=== 1) Tablolar ===")
    for row in run("SHOW TABLES"):
        print(" ", list(row.values())[0])

    print("\n=== 2) Sezon basina yaris sayisi ===")
    sql = """
        SELECT season_year, COUNT(*) AS race_count
        FROM races
        GROUP BY season_year
        ORDER BY season_year DESC
        LIMIT 5
    """
    for row in run(sql):
        print(f"  {row['season_year']}: {row['race_count']} yaris")

    print("\n=== 3) 2024 ilk 3 yaris (parametreli sorgu) ===")
    sql = """
        SELECT r.round_number, r.grand_prix_name, c.circuit_name
        FROM races r
        JOIN circuits c ON c.circuit_id = r.circuit_id
        WHERE r.season_year = %s
        ORDER BY r.race_start_date
        LIMIT 3
    """
    for row in run(sql, (2024,)):
        print(f"  R{row['round_number']}: {row['grand_prix_name']} @ {row['circuit_name']}")

    print("\n=== 4) En cok puan alan 3 pilot (2024) ===")
    sql = """
        SELECT d.driver_code,
               CONCAT(d.first_name, ' ', d.last_name) AS name,
               SUM(rr.points) AS total_pts
        FROM race_results rr
        JOIN drivers d ON d.driver_id = rr.driver_id
        WHERE rr.season_year = %s
        GROUP BY d.driver_id, d.driver_code, d.first_name, d.last_name
        ORDER BY total_pts DESC
        LIMIT 3
    """
    for row in run(sql, (2024,)):
        print(f"  {row['driver_code']} {row['name']}: {row['total_pts']} puan")

    print("\nTamamlandi.")


if __name__ == "__main__":
    main()
