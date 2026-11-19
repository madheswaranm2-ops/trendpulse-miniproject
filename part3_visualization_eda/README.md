# TrendPulse — Part 3: Visualization, EDA & Business Thinking

## Project scope
This folder is self-contained and analyzes the Trending YouTube Video Statistics dataset for the US, GB and IN. It includes its own data copies, notebook, dependencies and written interpretation guide. It does not read from another Part folder and makes no API calls or web requests.

## Dataset and source
Dataset: **Trending YouTube Video Statistics** (daily trending-video snapshots and category lookup). The files were supplied with the course/LMS project materials; the original public dataset is also known as the Trending YouTube Video Statistics dataset on Kaggle. The dataset is not claimed as original work.

## Folder contents
- `trendpulse_part3_visualization_eda.ipynb` — complete analysis, calculations, charts and interpretation outputs.
- `data/USvideos.csv`, `data/GBvideos.csv`, `data/INvideos.csv` — country snapshots.
- `data/categories.csv` — category lookup.
- `requirements.txt` — Python dependencies.

## Install
Use Google Colab (recommended) or Python 3.10+. In a local environment, run:

```bash
pip install -r requirements.txt
```

## Run end to end
1. Open `trendpulse_part3_visualization_eda.ipynb` in Google Colab or Jupyter.
2. Keep the notebook and its `data/` directory together. If using Colab, upload the folder or place the four CSV files in a folder named `data` beside the notebook; update `DATA_DIR` only if your location differs.
3. Select **Runtime → Restart and run all** (Colab) or **Kernel → Restart & Run All** (Jupyter).
4. Read the interpretation text printed immediately after each chart and the final summary tables/briefing. Plotly charts are interactive in notebook output.

## Design decisions and cleaning
- Country is added before concatenating the three files, preserving country-level comparisons.
- Dates are parsed explicitly: `trending_date` uses the source's `YY.DD.MM` representation; `publish_time` is parsed as UTC.
- Numeric metrics are coerced to numeric; invalid values become missing and are excluded only from calculations that require that metric. Boolean flags are normalized.
- Exact duplicate rows are removed. Records flagged `video_error_or_removed` are excluded from analysis. Rows without a usable `video_id` or trending date are excluded.
- Category names are joined from `categories.csv`; unmatched IDs are labelled `Unknown` rather than silently dropped.
- `days_to_trend` is the calendar-day difference between publication date (UTC date) and the first observed trending date for that video-country pair. Negative values, if any, are treated as invalid/missing and excluded from correlation calculations.
- For unique-video analyses, one row per `video_id` is used. Peak views and peak comments are maxima across all country-day observations. A video's first trending date is its earliest observed date across the three countries.
- Retention is measured as presence anywhere in the combined three-country data on the exact calendar offset from the first trending date. This is a descriptive snapshot measure, not proof of continuous audience attention.
- The funnel is nested: each stage is calculated from the preceding stage. Conversion rate is reported relative to the immediately preceding stage; the first stage is 100% of all unique videos. Threshold comparisons use strict `>` for median and 90th percentile; comments use `>= 1,000`.
- IQR outliers are retained: unusually high views/likes may represent genuine viral videos and are central to the business question. Counts are reported, not silently removed.

## Required interpretations and deliverables
The notebook reports the combined profile, affected-column missing percentages, cleaning counts, five Matplotlib charts and two Plotly charts. Each chart is followed by a 2–4 sentence interpretation and a sentence explaining why its chart type fits. It also reports views/likes mean, median and mode; skew conclusions based on their ordering; IQR outlier counts and keep/remove decisions; numeric correlation matrix and heatmap with the two strongest absolute off-diagonal pairs; the four-stage unique-video funnel and largest drop-off; day 2/3/5/7 retention with a retention curve and country comparison; weekly cohorts; and a 5–8 sentence evidence-backed content strategy briefing with a limitation.

## Reproducibility note
Results depend on the exact CSV snapshot supplied for the course. The notebook prints the actual computed values when run; no fixed sample numbers are hard-coded into the analysis. Charts are generated in notebook output and are not required as separate image files.
