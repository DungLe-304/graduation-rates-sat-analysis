"""Generate a SQL seed file from the GradRates.xlsx spreadsheet.

Usage:
  python src/generate_sql.py --input data/GradRates.xlsx --output sql/grad_rates.sql
"""

import argparse
import pandas as pd
import numpy as np

def sql_escape(s: str) -> str:
    return s.replace("'", "''")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", required=True, help="Path to GradRates.xlsx")
    ap.add_argument("--output", required=True, help="Path to write .sql file")
    args = ap.parse_args()

    df = pd.read_excel(args.input)
    df = df.dropna(subset=['College Name','Public (1)/ Private (2)','Graduation rate','Average SAT Math + Verbal']).copy()
    df['sector'] = np.where(df['Public (1)/ Private (2)'] == 1.0, 'Public', 'Private')
    df['sat_imputed'] = df['Unnamed: 5'].fillna('').astype(str).str.strip().eq('*').astype(int)
    df = df.rename(columns={'College Name':'college_name',
                            'State':'state',
                            'Graduation rate':'graduation_rate',
                            'Average SAT Math + Verbal':'sat_total'})
    df = df[['college_name','state','sector','graduation_rate','sat_total','sat_imputed']]

    lines = []
    lines.append("-- Graduation Rates vs SAT (seed data)")
    lines.append("DROP TABLE IF EXISTS colleges;")
    lines.append("""CREATE TABLE colleges (
  college_id      INTEGER PRIMARY KEY AUTOINCREMENT,
  college_name    TEXT NOT NULL,
  state           TEXT,
  sector          TEXT NOT NULL CHECK (sector IN ('Public','Private')),
  graduation_rate REAL NOT NULL,
  sat_total       INTEGER NOT NULL,
  sat_imputed     INTEGER NOT NULL DEFAULT 0 CHECK (sat_imputed IN (0,1))
);
""".strip())
    lines.append("BEGIN TRANSACTION;")
    for _, r in df.iterrows():
        name = sql_escape(str(r['college_name']))
        state = sql_escape(str(r['state'])) if pd.notna(r['state']) else ""
        sector = r['sector']
        grad = float(r['graduation_rate'])
        sat = int(round(float(r['sat_total'])))
        imp = int(r['sat_imputed'])
        lines.append(
            f"INSERT INTO colleges (college_name, state, sector, graduation_rate, sat_total, sat_imputed) "
            f"VALUES ('{name}', '{state}', '{sector}', {grad:.1f}, {sat}, {imp});"
        )
    lines.append("COMMIT;")
    with open(args.output, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))

if __name__ == "__main__":
    main()
