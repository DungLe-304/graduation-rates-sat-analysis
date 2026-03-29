# Graduation Rates vs SAT: Public vs Private Colleges

![Python](https://img.shields.io/badge/Python-3.9+-3776AB?logo=python&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-Notebook-F37626?logo=jupyter&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-SQLite%20%7C%20MySQL%20%7C%20Postgres-4479A1?logo=postgresql&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-22c55e)
![Status](https://img.shields.io/badge/Status-Complete-22c55e)

Statistical analysis exploring how SAT scores relate to graduation rates, with a comparison between public and private institutions. Originally a case study at Truman State University, extended with Python automation and SQL data loading.

---

## 📌 Overview

Using a dataset of **47 U.S. colleges** (20 public, 27 private), this project investigates:

- How strongly do SAT scores predict graduation rates?
- Does this relationship differ between public and private institutions?
- How well does the model predict Truman State University's own graduation rate?

The analysis includes exploratory data analysis (EDA), separate OLS regressions by sector, and an ANCOVA-style model with an interaction term.

---

## 🎯 Key Findings

### Correlations (SAT vs. Graduation Rate)

| Sector  | r     | p-value   | Interpretation             |
|---------|-------|-----------|----------------------------|
| Public  | 0.701 | 0.000574  | Strong positive correlation |
| Private | 0.572 | 0.001805  | Moderate positive correlation |

### Separate OLS Regressions

| Sector  | Intercept | Slope (per SAT point) | Equation |
|---------|-----------|-----------------------|----------|
| Public  | −51.385   | 0.1040                | `grad_rate = -51.385 + 0.104 × sat_total` |
| Private | 8.939     | 0.0617                | `grad_rate = 8.939 + 0.062 × sat_total`   |

Public colleges show a steeper slope, suggesting SAT scores are more predictive of graduation rates in that sector.

### Truman State University Prediction (SAT ≈ 1190)

| Predicted | Actual | Residual |
|-----------|--------|----------|
| 72.3%     | 76.0%  | +3.7 pp  |

The model slightly underpredicts Truman's graduation rate, which is consistent with the university performing above expectation for its SAT profile.

### ANCOVA-Style Interaction Model

```
graduation_rate ~ sat_total * sector
```

The interaction term (slope difference between sectors) yielded **p = 0.175**, indicating **no statistically significant difference** in the SAT–graduation rate slope between public and private institutions at α = 0.05. Despite the visual difference in slopes, we lack sufficient evidence to conclude the relationship fundamentally differs by sector.

---

## 📦 Data

- **Source:** Adapted from a course dataset, Statistics Department, Truman State University
- **Raw:** `data/GradRates.xlsx`
- **Cleaned:** `data/grad_rates_clean.csv`
- **SQL seed:** `sql/grad_rates.sql` (CREATE TABLE + INSERT statements)

### Variables

| Column          | Type    | Description                                      |
|-----------------|---------|--------------------------------------------------|
| `sector`        | String  | `Public` or `Private`                            |
| `graduation_rate` | Float | Graduation rate (%)                              |
| `sat_total`     | Int     | SAT Math + Verbal combined score                 |
| `sat_imputed`   | Binary  | `1` if SAT was imputed from ACT (marked `*` in raw data) |

---

## 📊 Figures

![Scatter with regression fits](figures/scatter_with_fits.png)

*Separate OLS regression lines for public (blue) and private (orange) colleges. Both sectors show a positive relationship, with public colleges displaying a steeper slope.*

---

## 🧱 Repo Structure

```
graduation-rates-sat-analysis/
├── data/
│   ├── GradRates.xlsx          # Raw dataset
│   └── grad_rates_clean.csv    # Cleaned, analysis-ready data
├── figures/
│   └── scatter_with_fits.png   # Scatter plot with regression lines
├── notebooks/
│   └── analysis.ipynb          # Full reproducible analysis (EDA → regression → diagnostics)
├── reports/
│   └── assignment.pdf          # Original case study prompt + write-up
├── sql/
│   └── grad_rates.sql          # SQL seed file (auto-generated)
├── src/
│   └── generate_sql.py         # Converts Excel/CSV to SQL seed
├── .gitignore
├── README.md
└── requirements.txt
```

---

## 🚀 Getting Started

### Prerequisites

- Python 3.9+
- `pip` and `venv`

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/DungLe-304/graduation-rates-sat-analysis.git
cd graduation-rates-sat-analysis

# 2. Create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate       # Windows: .venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. (Optional) Regenerate the SQL seed file
python3 src/generate_sql.py

# 5. Launch the notebook
jupyter lab
```

Open `notebooks/analysis.ipynb` and run all cells to reproduce the full analysis.

---

## ⚠️ Limitations

- **Small sample (n = 47):** Results may not generalize broadly to all U.S. colleges.
- **Imputed SAT values:** Some SAT scores were estimated from ACT scores (flagged by `sat_imputed = 1`), which may introduce measurement error.
- **Observational data:** Correlations and regressions do not imply causation — other institutional factors (funding, selectivity, support services) likely influence graduation rates.
- **Single year snapshot:** No longitudinal component; trends over time are not captured.

---

## 🔭 Future Work

- Expand dataset to include more institutions and additional years
- Incorporate additional predictors (acceptance rate, endowment, student-to-faculty ratio)
- Apply regularization techniques (Ridge/Lasso) to manage multicollinearity
- Build an interactive dashboard for exploring institution-level predictions

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
