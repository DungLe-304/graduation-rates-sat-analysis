# Graduation Rates vs SAT (Public vs Private)

**Goal:** Explore whether graduation rates differ between public vs private colleges, and how much of that difference is explained by incoming student selectivity (proxy: SAT Math+Verbal).

This project is based on a STAT 190 case study prompt (see `reports/assignment.pdf`) and uses the provided dataset of **20 public** and **27 private** schools.

## Data
- Raw: `data/GradRates.xlsx`
- Cleaned: `data/grad_rates_clean.csv`
- SQL seed: `sql/grad_rates.sql` (table + inserts)

Columns:
- `sector`: Public / Private  
- `graduation_rate`: percent  
- `sat_total`: SAT Math + Verbal  
- `sat_imputed`: 1 if SAT was imputed from ACT (marked with `*` in the spreadsheet)

## Key findings (reproducible)
Correlations (SAT vs graduation rate):
- **Public:** r = 0.701 (p = 0.0005742)
- **Private:** r = 0.572 (p = 0.001805)

Separate least-squares regressions:
- **Public:** graduation_rate = -51.385 + 0.103957 × sat_total
- **Private:** graduation_rate = 8.939 + 0.061701 × sat_total

**Truman prediction (SAT ≈ 1190):**
- Predicted: 72.3%
- Actual: 76%
- Error (Actual − Predicted): 3.7 percentage points

## Bonus: single model (ANCOVA-style)
I also fit one model with an interaction term:

`graduation_rate ~ sat_total * sector`

- Interaction (slope difference) p-value: 0.175

(See `notebooks/analysis.ipynb`.)

## Figures
![Scatter with regression fits](figures/scatter_with_fits.png)

## How to run
```bash
python -m venv .venv
source .venv/bin/activate  # Windows: .venv\Scripts\activate
pip install -r requirements.txt

# Open the notebook
jupyter lab
```

## Repo structure
- `notebooks/analysis.ipynb` – full, reproducible analysis
- `src/generate_sql.py` – converts the Excel sheet into a SQL seed file
- `sql/grad_rates.sql` – generated SQL (create table + inserts)
- `figures/` – charts used in the report/README
- `reports/` – assignment prompt + original write-up
- `data/` – raw + cleaned data
