"""Unit tests for src/generate_sql.py."""

import os
import sys
import tempfile
import unittest

import pandas as pd

# Allow imports from project root
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from src.generate_sql import sql_escape, load_and_clean, build_sql


def _make_df(**overrides):
    """Return a minimal valid DataFrame as returned by load_and_clean()."""
    data = {
        "college_name": ["Test University", "Another College"],
        "state": ["CA", "NY"],
        "sector": ["Public", "Private"],
        "graduation_rate": [75.0, 88.5],
        "sat_total": [1100, 1250],
        "sat_imputed": [0, 1],
    }
    data.update(overrides)
    return pd.DataFrame(data)


class TestSqlEscape(unittest.TestCase):
    def test_no_quotes(self):
        self.assertEqual(sql_escape("Harvard"), "Harvard")

    def test_single_quote(self):
        self.assertEqual(sql_escape("Mount St. Mary's"), "Mount St. Mary''s")

    def test_multiple_quotes(self):
        self.assertEqual(sql_escape("A'B'C"), "A''B''C")

    def test_empty_string(self):
        self.assertEqual(sql_escape(""), "")


class TestBuildSql(unittest.TestCase):
    def setUp(self):
        self.df = _make_df()
        self.sql = build_sql(self.df)

    def test_contains_create_table(self):
        self.assertIn("CREATE TABLE colleges", self.sql)

    def test_contains_drop_table(self):
        self.assertIn("DROP TABLE IF EXISTS colleges", self.sql)

    def test_contains_transaction(self):
        self.assertIn("BEGIN TRANSACTION;", self.sql)
        self.assertIn("COMMIT;", self.sql)

    def test_insert_count(self):
        inserts = [l for l in self.sql.splitlines() if l.startswith("INSERT INTO")]
        self.assertEqual(len(inserts), len(self.df))

    def test_insert_values_present(self):
        self.assertIn("Test University", self.sql)
        self.assertIn("Another College", self.sql)
        self.assertIn("'Public'", self.sql)
        self.assertIn("'Private'", self.sql)

    def test_sat_imputed_flag(self):
        # Row 1 has sat_imputed=1
        self.assertIn(", 1);", self.sql)

    def test_college_name_escaped(self):
        df = _make_df(college_name=["St. Mary's College", "Normal"])
        sql = build_sql(df)
        self.assertIn("St. Mary''s College", sql)

    def test_graduation_rate_format(self):
        # Values should be formatted with one decimal place
        self.assertIn("75.0", self.sql)
        self.assertIn("88.5", self.sql)


class TestLoadAndClean(unittest.TestCase):
    def test_missing_file_raises(self):
        with self.assertRaises(FileNotFoundError):
            load_and_clean("/nonexistent/path/file.xlsx")

    def test_missing_columns_raises(self):
        # Create a temp Excel file with wrong columns
        with tempfile.NamedTemporaryFile(suffix=".xlsx", delete=False) as tmp:
            tmp_path = tmp.name
        try:
            pd.DataFrame({"A": [1], "B": [2]}).to_excel(tmp_path, index=False)
            with self.assertRaises(ValueError) as ctx:
                load_and_clean(tmp_path)
            self.assertIn("Missing required columns", str(ctx.exception))
        finally:
            os.unlink(tmp_path)

    def test_valid_excel_loads(self):
        # Build a minimal Excel file matching the expected schema
        raw = pd.DataFrame({
            "College Name": ["Test U"],
            "State": ["CA"],
            "Public (1)/ Private (2)": [1.0],
            "Graduation rate": [80.0],
            "Average SAT Math + Verbal": [1100],
            "Unnamed: 5": [None],
        })
        with tempfile.NamedTemporaryFile(suffix=".xlsx", delete=False) as tmp:
            tmp_path = tmp.name
        try:
            raw.to_excel(tmp_path, index=False)
            df = load_and_clean(tmp_path)
            self.assertEqual(len(df), 1)
            self.assertEqual(df.iloc[0]["sector"], "Public")
            self.assertEqual(df.iloc[0]["sat_imputed"], 0)
            self.assertListEqual(
                list(df.columns),
                ["college_name", "state", "sector", "graduation_rate", "sat_total", "sat_imputed"],
            )
        finally:
            os.unlink(tmp_path)

    def test_private_sector_mapping(self):
        raw = pd.DataFrame({
            "College Name": ["Private U"],
            "State": ["NY"],
            "Public (1)/ Private (2)": [2.0],
            "Graduation rate": [90.0],
            "Average SAT Math + Verbal": [1300],
            "Unnamed: 5": ["*"],
        })
        with tempfile.NamedTemporaryFile(suffix=".xlsx", delete=False) as tmp:
            tmp_path = tmp.name
        try:
            raw.to_excel(tmp_path, index=False)
            df = load_and_clean(tmp_path)
            self.assertEqual(df.iloc[0]["sector"], "Private")
            self.assertEqual(df.iloc[0]["sat_imputed"], 1)
        finally:
            os.unlink(tmp_path)


if __name__ == "__main__":
    unittest.main()
