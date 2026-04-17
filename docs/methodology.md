# Methodology & Analysis Write-up

**Project:** Graduation Rates vs. SAT Scores — Public vs. Private Colleges  
**Author:** Tony Le  
**Dataset:** 47 U.S. colleges (20 public, 27 private)

---

## 1. Research Question

Does the relationship between SAT scores and 6-year graduation rates differ significantly between public and private U.S. colleges? Specifically, we test whether institutional sector (public vs. private) moderates the association between standardized test performance and graduation outcomes.

---

## 2. Data

### Source
Data were collected for 47 U.S. institutions, covering:
- 6-year graduation rate (%)
- Combined SAT score (Math + Verbal)
- Institutional sector (Public / Private)

### Data Cleaning
Raw data were loaded from `GradRates.xlsx`. The following steps were applied:

1. **Column standardization** — renamed columns to `snake_case` for consistency
2. **SAT imputation** — five institutions reported ACT-only scores; SAT equivalents were estimated using published SAT–ACT concordance tables (College Board, 2018). These records are flagged with `sat_imputed = 1`
3. **Outlier inspection** — no records were removed; all values fell within plausible ranges

Cleaned data exported to `data/grad_rates_clean.csv`.

---

## 3. Exploratory Data Analysis

Separate scatter plots and summary statistics were computed for public and private institutions. Both sectors displayed a positive, roughly linear relationship between SAT total and graduation rate, supporting the appropriateness of linear regression.

**Summary statistics:**

| Metric | Public (n=20) | Private (n=27) |
|--------|--------------|----------------|
| Mean graduation rate | — | — |
| Mean SAT total | — | — |
| Graduation rate range | — | — |

*(See `notebooks/analysis.ipynb` for computed values.)*

---

## 4. Methods

### 4.1 Pearson Correlation

Pearson's r was computed separately for each sector to quantify the strength of the linear association before fitting regression models.

### 4.2 Separate OLS Regressions

Individual ordinary least squares (OLS) models were fit for each sector:

```
graduation_rate ~ sat_total    [Public only]
graduation_rate ~ sat_total    [Private only]
```

This allows comparison of intercepts and slopes across sectors without imposing any interaction constraint.

### 4.3 ANCOVA-Style Interaction Model

A single model with an interaction term was fit to formally test whether the slopes differ across sectors:

```
graduation_rate ~ sat_total + sector + sat_total:sector
```

The interaction term coefficient (`sat_total:sector`) captures the slope difference between public and private institutions. A significant p-value (< 0.05) would indicate that sector moderates the SAT–graduation relationship.

### 4.4 Sensitivity Analysis

To assess robustness, the full analysis was repeated excluding the five records with imputed SAT values (`sat_imputed = 1`). Results were compared to the full-sample analysis.

---

## 5. Results

### Pearson Correlation

| Sector | r | p-value |
|--------|---|---------|
| Public | 0.701 | 0.0006 |
| Private | 0.572 | 0.0018 |

Both correlations are statistically significant (α = 0.05), indicating a meaningful positive relationship in each sector.

### OLS Regression Coefficients

| Sector | Intercept | Slope | Interpretation |
|--------|-----------|-------|----------------|
| Public | −51.385 | +0.1040 | Each +1 SAT point → +0.104 pp graduation rate |
| Private | +8.939 | +0.0617 | Each +1 SAT point → +0.062 pp graduation rate |

The public model's steeper slope suggests that SAT scores are more predictive of graduation outcomes among public institutions.

### Interaction Test

| Term | Coefficient | p-value |
|------|-------------|---------|
| `sat_total:sector[Public]` | — | 0.175 |

The interaction term is **not statistically significant** (p = 0.175 > 0.05). We fail to reject the null hypothesis that the slopes are equal across sectors. While public colleges exhibit a descriptively steeper slope, this difference is not reliably distinguishable from sampling variability given the current dataset size.

### Regression Diagnostics

Residuals vs. Fitted, Q-Q plots, and Cook's Distance were inspected for each model. No severe violations of linearity, homoscedasticity, or normality were detected. No high-leverage outliers with disproportionate influence were identified (all Cook's Distance values < 0.5).

### Sensitivity Analysis

Excluding imputed records (n = 42) yielded consistent direction and magnitude of coefficients, supporting the robustness of findings to the imputation assumption.

---

## 6. Limitations

1. **Small sample (n = 47)** — Low statistical power limits the ability to detect small-to-moderate interaction effects. The non-significant interaction (p = 0.175) should be interpreted cautiously; a larger sample may yield a significant result.

2. **Cross-sectional design** — This analysis is observational and cross-sectional. Causal claims about SAT scores *causing* higher graduation rates are not supported.

3. **SAT imputation** — Concordance-based ACT-to-SAT conversion introduces measurement error for the five affected institutions.

4. **Omitted variables** — Many institutional factors correlated with both SAT scores and graduation rates (selectivity, endowment, student support services) are not included. Coefficients should not be interpreted as causal effects.

5. **Temporal scope** — Data represent a single time point; trends over time are not captured.

---

## 7. Conclusion

SAT total scores are significantly positively associated with 6-year graduation rates in both public and private U.S. colleges. The association is descriptively stronger among public institutions (r = 0.70 vs. r = 0.57), and the public-sector regression model shows a steeper slope. However, a formal test of the slope difference (ANCOVA interaction, p = 0.175) does not reach statistical significance, leaving open the question of whether sector truly moderates this relationship — a question better addressed with a larger dataset.

---

## 8. Reproducibility

All analysis steps are fully reproducible via `notebooks/analysis.ipynb`. See `README.md` for setup instructions.
