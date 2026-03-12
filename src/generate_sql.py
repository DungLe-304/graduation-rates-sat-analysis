"""Generate a SQL seed file from the GradRates.xlsx spreadsheet.

Usage:
  python src/generate_sql.py --input data/GradRates.xlsx --output sql/grad_rates.sql
"""

import argparse
import sys
import pandas as pd
import numpy as np


def sql_escape(s: str) -> str:
    """Escape single quotes in a string for safe SQL insertion."""
    return s.replace("'", "''")


def load_and_clean(input_path: str) -> pd.DataFrame:
    """Load Excel file and return a cleaned DataFrame.

    Args:
        input_path: Path to the GradRates.xlsx file.

    Returns:
        A cleaned DataFrame with standardized column names.

    Raises:
        FileNotFoundError: If the input file does not exist.
        ValueError: If required columns are missing from the file.
    """
    try:
        df = pd.read_excel(input_path)
    except FileNotFoundError:
        raise FileNotFoundError(f"Input file not found: {input_path}")
    except Exception as e:
        raise IOError(f"Failed to read Excel file '{input_path}': {e}") from e

    required_cols = [
        'College Name',
        'Public (1)/ Private (2)',
        'Graduation rate',
        'Average SAT Math + Verbal',
    ]
    missing = [c for c in required_cols if c not in df.columns]
    if missing:
        raise ValueError(f"Missing required columns: {missing}")

    df = df.dropna(subset=required_cols).copy()
    df['sector'] = np.where(df['Public (1)/ Private (2)'] == 1.0, 'Public', 'Private')
    df['sat_imputed'] = (
        df['Unnamed: 5'].fillna('').astype(str).str.strip().eq('*').astype(int)
    )
    df = df.rename(columns={
        'College Name': 'college_name',
        'State': 'state',
        'Graduation rate': 'graduation_rate',
        'Average SAT Math + Verbal': 'sat_total',
    })
    return df[['college_name', 'state', 'sector', 'graduation_rate', 'sat_total', 'sat_imputed']]


def build_sql(df: pd.DataFrame) -> str:
    """Build a SQL seed string from a cleaned DataFrame.

    Args:
        df: Cleaned DataFrame returned by load_and_clean().

    Returns:
        A string containing the full SQL DDL and INSERT statements.
    """
    lines = []
    lines.append("-- Graduation Rates vs SAT (seed data)")
    lines.append("DROP TABLE IF EXISTS colleges;")
    lines.append(
        "CREATE TABLE colleges (\n"
        "  college_id      INTEGER PRIMARY KEY AUTOINCREMENT,\n"
        "  college_name    TEXT NOT NULL,\n"
        "  state           TEXT,\n"
        "  sector          TEXT NOT NULL CHECK (sector IN ('Public','Private')),\n"
        "  graduation_rate REAL NOT NULL,\n"
        "  sat_total       INTEGER NOT NULL,\n"
        "  sat_imputed     INTEGER NOT NULL DEFAULT 0 CHECK (sat_imputed IN (0,1))\n"
        ");"
    )
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
    return "\n".join(lines)


def main() -> None:
    """Parse arguments, generate SQL, and write to output file."""
    ap = argparse.ArgumentParser(
        description="Convert GradRates.xlsx to a SQL seed file."
    )
    ap.add_argument("--input", required=True, help="Path to GradRates.xlsx")
    ap.add_argument("--output", required=True, help="Path to write .sql file")
    args = ap.parse_args()

    try:
        df = load_and_clean(args.input)
        sql = build_sql(df)
    except (FileNotFoundError, ValueError, IOError) as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

    try:
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(sql)
        print(f"Wrote {len(df)} rows to '{args.output}'.")
    except OSError as e:
        print(f"Error writing output file '{args.output}': {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
